extends Control
class_name UI

##REFS
@onready var game_manager: GameManager = get_parent()
@export var game_over_text: Label
@export var score_label: Label

func _ready() -> void:
	print(game_manager.score)

func update_score(new_score: int) -> void:
	score_label.text = str(new_score)

func show_game_over() -> void:
	game_over_text.show()

func hide_game_over() -> void:
	game_over_text.hide()
