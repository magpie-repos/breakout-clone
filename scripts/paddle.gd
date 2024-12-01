extends StaticBody2D

var window_scale: float = 1
var paddle_move_speed: float = 250
@onready var window_size: Vector2 = get_window().size
##Refs
@onready var sprite_size: Vector2 = $PaddleSprite.texture.get_size()

func _ready() -> void:
	add_to_group("paddle")

func _process(delta: float) -> void:
	if Input.is_anything_pressed():
		var move_vector = Input.get_vector("left", "right", "void", "void")
		position += move_vector * paddle_move_speed * delta
		
		clamp_to_window()

func clamp_to_window() -> void:
	var left_limit = 0 + (sprite_size.x / 2) * scale.x
	var right_limit = window_size.x - (sprite_size.x / 2) * scale.x
	if position.x < left_limit:
		position.x = left_limit	
	if position.x > right_limit:
		position.x = right_limit
