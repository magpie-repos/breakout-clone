extends Node2D

var target_rows: int = 10
var target_columns: int = 6
var top_brick_margin: float = 50
var bottom_brick_margin: float = 500
var side_brick_margin: float = 0

var brick_scene: PackedScene = preload("res://scenes/brick.tscn")
var brick_size: Vector2 = Vector2(64, 64)
@onready var window_size: Vector2 = get_viewport().size

func _ready() -> void:
	spawn_bricks()

func spawn_bricks() -> void:
	var space_per_column: float = (window_size.x - side_brick_margin * 2) / target_columns
	var space_per_row: float = (window_size.y - top_brick_margin - bottom_brick_margin) / target_rows
	for row in target_rows:
		for col in target_columns:
			var new_brick: Brick = brick_scene.instantiate()
			new_brick.scale.x = (space_per_column / brick_size.x)
			new_brick.scale.y = (space_per_row / brick_size.y)
			new_brick.position.x = (col * space_per_column) + side_brick_margin + space_per_column / 2
			new_brick.position.y = (row * space_per_row) + top_brick_margin + space_per_row / 2
			add_child(new_brick)
