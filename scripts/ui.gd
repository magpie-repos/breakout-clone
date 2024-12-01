extends Control
class_name UI

var score_str_size: int = 8
var level_str_size: int = 2 
##Main UI Refs
@export var main_ui: Control
@export var score_label: Label
@export var level_label: Label
@export var lives_label: Label
##GameOver UI Refs
@export var game_over_ui: Control
@export var game_over_score: Label
@export var game_over_hi_score: Label

@export var tutorial_ui: Control

func show_tutorial() -> void:
	tutorial_ui.show()

func hide_tutorial() -> void:
	main_ui.show()
	tutorial_ui.hide()

func update_score(new_score: int) -> void:
	var score_string: String = pad_text(str(new_score), score_str_size)
	score_label.text = score_string

func update_level(new_level: int) -> void:
	var level_string: String = pad_text(str(new_level), level_str_size)
	level_string = "lvl " + level_string
	level_label.text = level_string
	
func update_lives(new_lives: int) -> void:
	var lives_string: String =  str(new_lives) + " lives"
	lives_label.text = lives_string

func pad_text(str_to_pad: String, target_length: int) -> String:
	var padded_str: String = str_to_pad
	if padded_str.length() < target_length:
		for i in range(0, target_length - padded_str.length()):
			padded_str = "0" + padded_str 
	return padded_str

func hide_game_over() -> void:
	game_over_ui.hide()
	main_ui.show()

func show_game_over(score: int, hi_score: int) -> void:
	game_over_hi_score.text = "hi score: " + pad_text(str(hi_score), score_str_size)
	game_over_score.text =    "score:    " + pad_text(str(score), score_str_size)
	
	main_ui.hide()
	game_over_ui.show()
