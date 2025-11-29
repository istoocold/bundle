extends Node2D
const MAIN_MENU_PATH = "res://control.tscn"
@onready var board = $UI/PuzzleContainer/VBoxContainer/PuzzleBoard
@onready var reset_button = $UI/ButtonContainer/ResetButton
@onready var back_button = $UI/ButtonContainer/backbutton
func _ready():
	
	reset_button.pressed.connect(_on_reset_pressed)
	back_button.pressed.connect(_on_back_pressed)

	
	board.initialize_puzzle()

func _on_reset_pressed():
	board.reset_puzzle()
func _on_back_pressed():
	# Return to main menu
	get_tree().change_scene_to_file(MAIN_MENU_PATH)
