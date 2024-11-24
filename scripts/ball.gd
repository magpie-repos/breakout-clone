extends RigidBody2D
class_name Ball
##Movement Vars
var speed: float
var velocity: Vector2
var vector: Vector2
##Refs
@onready var window_size: Vector2 = get_window().size
@onready var sprite_size: Vector2 = $BallSprite.texture.get_size()

signal points_scored(amount: int)

func _physics_process(delta: float) -> void:
	velocity = vector.normalized() * speed
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	
	if collision:
		var body: Node2D = collision.get_collider()
		if body:
			##Handle special collision cases
			if body.is_in_group("paddle"):
				var mod_angle: Vector2 = position.direction_to(body.position)
				vector = (vector.bounce(collision.get_normal()) + (mod_angle * -1)).normalized()
			else:
				vector = vector.bounce(collision.get_normal())
			
			##Destroy bricks
			if body.is_in_group("brick"):
				points_scored.emit(body.value)
				body.queue_free()


func setup_ball(init_pos: Vector2, init_vector: Vector2, init_speed: float) -> void:
	position = init_pos
	vector = init_vector
	speed = init_speed
	
