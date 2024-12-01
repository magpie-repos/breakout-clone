extends Node2D
class_name GameManager
##Game Vars
var game_over: bool = false
var lives: int = 3
var max_lives: int = 5
var score: int = 0
var curr_level: int = 1
var hi_score: int
var ball_start_pos: Vector2 = Vector2(0, 650)
var ball_speed: float = 175
var spawned_ball: Ball
var spawned_paddle: StaticBody2D

##Refs
@onready var window_size: Vector2 = get_window().size
@onready var ball_scene: PackedScene = preload("res://scenes/ball.tscn")
@onready var paddle_scene: PackedScene = preload("res://scenes/paddle.tscn")
@onready var ui: UI = $UI

func _ready() -> void:
	hi_score = load_score()
	new_game()

func _process(delta: float) -> void:
	if score > hi_score:
		save_score(score)
		hi_score = score
	
	##Check if level cleared
	if not game_over:
		if not get_tree().get_first_node_in_group("brick"):
			win_level()
	
	if game_over:
		if Input.is_action_just_pressed("reset"):
			new_game()

	debug_tools()

func debug_tools() -> void:
	if Input.is_action_just_pressed("debug_lvl_clear"):
		win_level()

func win_level() -> void:
	curr_level += 1
	ui.update_level(curr_level)
	if lives < max_lives:
		lives += 1
	ui.update_lives(lives)
	if spawned_ball:
		clean_up_ball(spawned_ball)
	
	##TODO:
	##- Show level clear Anim
	##- Play sound
	$Level/Bricks.clear_bricks()
	$Level/Bricks.spawn_bricks()
	spawned_ball = spawn_ball()
	
	spawned_paddle.position = Vector2(window_size.x / 2, 840)

func new_game() -> void:
	game_over = false
	score = 0
	curr_level = 1
	lives = 3
	
	ui.hide_game_over()
	ui.update_score(score)
	ui.update_level(curr_level)
	ui.update_lives(lives)
	
	ball_start_pos.x = window_size.x / 2
	spawned_ball = spawn_ball()
	
	spawned_paddle = paddle_scene.instantiate()
	spawned_paddle.position = Vector2(window_size.x / 2, 840)
	add_child(spawned_paddle)

func end_game() -> void:
	curr_level = 0
	game_over = true
	$Level/Bricks.clear_bricks()
	ui.show_game_over(score, hi_score)
	spawned_paddle.queue_free()

func spawn_ball() -> Ball:
	var ball: Ball = ball_scene.instantiate()
	var ball_vector: Vector2 = Vector2(randf_range(-1, 1), 1).normalized() 
	ball.setup_ball(ball_start_pos, ball_vector, ball_speed)
	ball.connect("points_scored", _on_points_scored)
	ball.connect("ball_die", _on_ball_die)
	add_child(ball)
	return ball

func clean_up_ball(ball: Ball) -> void:
	ball.disconnect("points_scored", _on_points_scored)
	ball.disconnect("ball_die", _on_ball_die)
	ball.queue_free()

func _on_points_scored(value: float):
	score += value * curr_level
	ui.update_score(score)

func _on_ball_die(dead_ball: Ball) -> void:
	lives -= 1
	ui.update_lives(lives)
	clean_up_ball(dead_ball)
	if lives > 0:
		spawned_ball = spawn_ball()
		spawned_paddle.position = Vector2(window_size.x / 2, 840)
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
