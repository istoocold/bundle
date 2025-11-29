extends Control

# Edit these paths to match your level scene files
const LEVEL1_PATH = "res://level1.tscn"  # Change this to your Level 1 path
const LEVEL2_PATH = "res://level2.tscn"  # Change this to your Level 2 path

# Reference to the buttons
@onready var level1_button = $lvl1
@onready var level2_button = $lvl2

func _ready():
	# Connect button signals
	level1_button.pressed.connect(_on_level1_pressed)
	level2_button.pressed.connect(_on_level2_pressed)

func _on_level1_pressed():
	# Change to Level 1 scene
	get_tree().change_scene_to_file(LEVEL1_PATH)


func _on_level2_pressed():
	# Change to Level 2 scene
	get_tree().change_scene_to_file(LEVEL2_PATH)
	
