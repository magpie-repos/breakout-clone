extends Node2D
class_name GameManager
##Game Vars
var game_over: bool = false
var lives: int = 3
var score: int = 0
var ball_start_pos: Vector2 = Vector2(0, 650)
var ball_speed: float = 175
##Refs
@onready var window_size: Vector2 = get_window().size
@onready var ball_scene: PackedScene = preload("res://scenes/ball.tscn")
@onready var paddle_scene: PackedScene = preload("res://scenes/paddle.tscn")

func _ready() -> void:
	new_game()
	ball_start_pos.x = window_size.x / 2
	spawn_ball()
	
func new_game() -> void:
	score = 0
	lives = 3
	game_over = false

func end_game() -> void:
	game_over = true
	print("Game Over")

func spawn_ball():
	var ball: Ball = ball_scene.instantiate()
	var ball_vector: Vector2 = Vector2(randf_range(-1, 1), 1).normalized() 
	ball.setup_ball(ball_start_pos, ball_vector, ball_speed)
	ball.connect("points_scored", _on_points_scored)
	add_child(ball)
	
func _on_points_scored(value: float):
	score += value
