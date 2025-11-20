extends Node2D

@onready var board = $UI/PuzzleContainer/VBoxContainer/PuzzleBoard
@onready var reset_button = $UI/PuzzleContainer/VBoxContainer/ButtonContainer/ResetButton

func _ready():
	
	reset_button.pressed.connect(_on_reset_pressed)
	
	
	board.initialize_puzzle()

func _on_reset_pressed():
	board.reset_puzzle()
