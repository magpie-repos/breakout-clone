extends StaticBody2D
class_name Brick

var value: int = 5
var color_array: Array[Color] = [
	Color.hex(0xed1c24ff), ##RED
	Color.hex(0xff7f27ff), ##ORANGE
	Color.hex(0xffc90eff), ##YELLOW (piss)
	Color.hex(0x22b14cff), ##GREEN
	Color.hex(0x00a2e8ff), ##BLUE
	Color.hex(0xa349a4ff)  ##PURPLE
]
@onready var texture_size: Vector2 = Vector2($BrickStroke.texture.width, $BrickStroke.texture.height)
var init_window: Vector2 = Vector2(600, 900)

func _ready() -> void:
	add_to_group("brick")
	var brick_texture: GradientTexture2D = generate_gradient_texture()
	$BrickSprite.texture = brick_texture

func generate_gradient_texture() -> GradientTexture2D:
	var new_color: Color = color_array[randi_range(0, color_array.size() - 1)]
	var gradient_color_points: PackedColorArray
	
	for i in range(0, 1):
		gradient_color_points.append(new_color)	
		
	var new_gradient: GradientTexture2D = GradientTexture2D.new()
	new_gradient.gradient = Gradient.new()
	new_gradient.gradient.colors = gradient_color_points
	new_gradient.height = $BrickSprite.texture.height
	new_gradient.width = $BrickSprite.texture.width
	
	return new_gradient
