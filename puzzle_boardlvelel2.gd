extends GridContainer

const GRID_SIZE = 4
const TILE_SIZE = 90

var grid = []
var empty_pos = Vector2i(3, 3)
var tiles = []
var empty_space_node
var tile_textures = []

func _ready():
	empty_space_node = get_node("EmptySpace")
	
	for i in range(15):
		var tile = get_node("Tile" + str(i + 1))
		tiles.append(tile)
		
		tile.custom_minimum_size = Vector2(TILE_SIZE, TILE_SIZE)
		tile.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		tile.stretch_mode = TextureRect.STRETCH_SCALE
		tile.mouse_filter = Control.MOUSE_FILTER_STOP
		
		tile.gui_input.connect(func(event): handle_tile_input(event, tile))

func load_source_image():
	tile_textures.clear()
	
	var paths = [
		"res://lvl2/tile_0_0.png",
		"res://lvl2/tile_0_1.png",
		"res://lvl2/tile_0_2.png",
		"res://lvl2/tile_0_3.png",
		"res://lvl2/tile_1_0.png",
		"res://lvl2/tile_1_1.png",
		"res://lvl2/tile_1_2.png",
		"res://lvl2/tile_1_3.png",
		"res://lvl2/tile_2_0.png",
		"res://lvl2/tile_2_1.png",
		"res://lvl2/tile_2_2.png",
		"res://lvl2/tile_2_3.png",
		"res://lvl2/tile_3_0.png",
		"res://lvl2/tile_3_1.png",
		"res://lvl2/tile_3_2.png"
		
	]
	
	for path in paths:
		var tex = load(path) as Texture2D
		if tex:
			tile_textures.append(tex)
		else:
			push_error("Failed to load tile: " + path)

func setup_grid():
	grid = []
	for row in range(GRID_SIZE):
		var grid_row = []
		for col in range(GRID_SIZE):
			if row == GRID_SIZE - 1 and col == GRID_SIZE - 1:
				grid_row.append(null)
			else:
				var idx = row * GRID_SIZE + col
				grid_row.append(tiles[idx])
				tiles[idx].set_meta("grid_pos", Vector2i(col, row))
				tiles[idx].set_meta("tile_index", idx)
		grid.append(grid_row)
	
	empty_pos = Vector2i(3, 3)

func is_valid_position(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < GRID_SIZE and pos.y >= 0 and pos.y < GRID_SIZE

func get_valid_moves() -> Array:
	var moves = []
	var dirs = [Vector2i(-1, 0), Vector2i(1, 0), Vector2i(0, -1), Vector2i(0, 1)]
	
	for d in dirs:
		var check = empty_pos + d
		if is_valid_position(check):
			moves.append(check)
	
	return moves

func shuffle_puzzle():
	var moves = 150 + randi() % 150
	
	for i in range(moves):
		var valid = get_valid_moves()
		if valid.size() > 0:
			var pick = valid[randi() % valid.size()]
			swap_with_empty(pick)

func initialize_puzzle():
	load_source_image()
	setup_grid()
	shuffle_puzzle()
	update_tile_positions()

func is_adjacent_to_empty(pos: Vector2i) -> bool:
	var dist = abs(pos.x - empty_pos.x) + abs(pos.y - empty_pos.y)
	return dist == 1

func swap_with_empty(tile_pos: Vector2i):
	var tile = grid[tile_pos.y][tile_pos.x]
	
	var tile_idx = tile.get_index()
	var empty_idx = empty_space_node.get_index()
	
	move_child(tile, empty_idx)
	move_child(empty_space_node, tile_idx)
	
	grid[empty_pos.y][empty_pos.x] = tile
	grid[tile_pos.y][tile_pos.x] = null
	
	tile.set_meta("grid_pos", empty_pos)
	empty_pos = tile_pos

func handle_tile_input(event: InputEvent, tile: TextureRect):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		on_tile_clicked(tile)

func on_tile_clicked(tile):
	var pos = tile.get_meta("grid_pos")
	
	if is_adjacent_to_empty(pos):
		swap_with_empty(pos)
		
		if check_solved():
			on_puzzle_solved()

func update_tile_positions():
	for row in range(GRID_SIZE):
		for col in range(GRID_SIZE):
			var target = row * GRID_SIZE + col
			var tile = grid[row][col]
			
			if tile == null:
				move_child(empty_space_node, target)
			else:
				move_child(tile, target)
				var idx = tile.get_meta("tile_index")
				tile.texture = tile_textures[idx]

func check_solved() -> bool:
	for row in range(GRID_SIZE):
		for col in range(GRID_SIZE):
			var expected = row * GRID_SIZE + col
			
			if row == GRID_SIZE - 1 and col == GRID_SIZE - 1:
				if grid[row][col] != null:
					return false
			else:
				var tile = grid[row][col]
				if tile == null or tile.get_meta("tile_index") != expected:
					return false
	
	return true

func on_puzzle_solved():
	print("Puzzle solved!")
	
	if OS.has_feature("web"):
		JavaScriptBridge.eval("window.postMessage({type: 'puzzle_solved'}, '*');")

func reset_puzzle():
	shuffle_puzzle()
	update_tile_positions()
