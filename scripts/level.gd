extends Node2D


@onready var window_size: Vector2 = get_window().size
@onready var world_boundary_right: CollisionShape2D = $LevelBoundary/WorldBorderRight

func _ready() -> void:
	world_boundary_right.position.x = window_size.x
