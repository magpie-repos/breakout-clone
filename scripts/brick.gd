extends StaticBody2D
class_name Brick

var value: int = 1

func _ready() -> void:
	add_to_group("brick")
