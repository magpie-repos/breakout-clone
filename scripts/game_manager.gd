extends Node2D
class_name GameManager
##Game Vars
var game_over: bool = false
var lives: int = 3
var score: int
var hi_score: int
var ball_start_pos: Vector2 = Vector2(0, 650)
var ball_speed: float = 175
var curr_level: int = 0
##Refs
@onready var window_size: Vector2 = get_window().size
@onready var ball_scene: PackedScene = preload("res://scenes/ball.tscn")
@onready var paddle_scene: PackedScene = preload("res://scenes/paddle.tscn")
@onready var ui: UI = $UI
@onready var level_list: Array[PackedScene] = [
	preload("res://scenes/levels/level_1.tscn")
]

func _ready() -> void:
	hi_score = load_score()
	new_game()
	ball_start_pos.x = window_size.x / 2
	spawn_ball()

func _process(delta: float) -> void:
	if score > hi_score:
		save_score(score)
		hi_score = score

	if not get_tree().get_first_node_in_group("bricks"):
		level_clear()

func load_level(level_id: int) -> void:
	add_child(level_list[level_id].instantiate())

func level_clear():
	curr_level += 1
	get_tree().get_first_node_in_group("level").queue_free()
	##TODO level clear anim
	##TODO check if more levels. if no show win
	##TODO more levels to play

func new_game() -> void:
	score = 0
	ui.update_score(score)
	lives = 3
	game_over = false
	ui.hide_game_over()
	load_level(0)

func end_game() -> void:
	game_over = true
	ui.show_game_over()

func spawn_ball():
	var ball: Ball = ball_scene.instantiate()
	var ball_vector: Vector2 = Vector2(randf_range(-1, 1), 1).normalized() 
	ball.setup_ball(ball_start_pos, ball_vector, ball_speed)
	ball.connect("points_scored", _on_points_scored)
	ball.connect("ball_die", _on_ball_die)
	add_child(ball)
	
func _on_points_scored(value: float):
	score += value
	ui.update_score(score)

func _on_ball_die(dead_ball: Ball) -> void:
	lives -= 1
	dead_ball.disconnect("points_scored", _on_points_scored)
	dead_ball.disconnect("ball_die", _on_ball_die)
	if lives > 0:
		spawn_ball()
	elif lives == 0:
		end_game()
	else:
		print("LIVE BORKEN NEED FIXIN")

func load_score() -> int:
	var hi_score: int
	if FileAccess.file_exists("score.save"):
		var file = FileAccess.open("score.save", FileAccess.READ)
		hi_score = file.get_16()
	else:
		var file = FileAccess.open("score.save", FileAccess.WRITE)
		hi_score = 0
	
	return hi_score

func save_score(score: int) -> void:
	var file = FileAccess.open("score.save", FileAccess.WRITE)
	file.store_16(2225)
	file.close()
