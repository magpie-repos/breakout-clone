extends Node2D
class_name GameManager
##Game Vars
var game_over: bool
var tutorial_state: bool
var curr_level: int
var max_lives: int = 5
var lives: int
var score: int
var hi_score: int
##Ball Vars
var ball_start_pos: Vector2 = Vector2(0, 650)
var ball_speed: float = 175
##Spawned Object Refs
var spawned_ball: Ball
var spawned_paddle: StaticBody2D
##@onready Vars
@onready var window_size: Vector2 = get_window().size
@onready var ball_scene: PackedScene = preload("res://scenes/ball.tscn")
@onready var paddle_scene: PackedScene = preload("res://scenes/paddle.tscn")
@onready var ball_explosion: PackedScene = preload("res://scenes/ball_explosion.tscn")
@onready var ui: UI = $UI
@onready var brick_spawner: BrickSpawner = $Level/Bricks
##SFX
@onready var ball_die_sfx: AudioStreamPlayer2D = $SFX/BallDieSFX
@onready var level_clear_sfx: AudioStreamPlayer2D = $SFX/LevelClearSFX
@onready var lose_sfx: AudioStreamPlayer2D = $SFX/LoseSFX

func _ready() -> void:
	hi_score = load_score()
	
	tutorial_state = true

func _process(delta: float) -> void:
	if tutorial_state:
		ui.show_tutorial()
		if Input.is_anything_pressed():
			tutorial_state = false
			ui.hide_tutorial()
			new_game()
	else:
		if score > hi_score:
			save_score(score)
			hi_score = score
		if game_over:
			##Enable restarting after loss
			if Input.is_action_just_pressed("reset"):
				new_game()
		else:
			if not get_tree().get_first_node_in_group("brick"):
				print("here!")
				print(game_over)
				win_level()


func win_level() -> void:
	level_clear_sfx.play()
	
	curr_level += 1
	if lives < max_lives:
		lives += 1
	
	ui.update_level(curr_level)
	ui.update_lives(lives)
	
	if spawned_ball:
		clean_up_ball(spawned_ball)
	spawned_ball = spawn_ball()
 
	brick_spawner.clear_bricks()
	brick_spawner.spawn_bricks()
	
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
	
	brick_spawner.spawn_bricks()

func end_game() -> void:
	lose_sfx.play()
	game_over = true
	brick_spawner.clear_bricks()
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
	
	var spawned_explosion: Node2D = ball_explosion.instantiate()
	spawned_explosion.position = spawned_ball.position
	add_child(spawned_explosion)
	clean_up_ball(dead_ball)

	ball_die_sfx.play()
	
	if lives > 0:
		spawned_ball = spawn_ball()
		spawned_paddle.position = Vector2(window_size.x / 2, 840)
	else:
		end_game()

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
	file.store_16(score)
	file.close()
