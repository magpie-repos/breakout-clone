extends RigidBody2D
class_name Ball
##Movement Vars
var speed: float
var velocity: Vector2
var vector: Vector2
##Pwr Up Vars
var smash_used: bool = false
var smash_active: bool = false
var smash_speed_mult: float = 4
var smash_speed_decay: float = 0.998
##Refs
@onready var window_size: Vector2 = get_window().size
@onready var sprite_size: Vector2 = $BallSprite.texture.get_size()
@export var ball_bounce_sfx: AudioStreamPlayer2D


signal points_scored(amount: int)
signal ball_die(Ball)

func _ready() -> void:
	velocity = vector.normalized() * speed

func _process(delta: float) -> void:
	if is_out_of_bounds(sprite_size, window_size, scale):
		ball_die.emit(self)
		queue_free()

func _physics_process(delta: float) -> void:
	
	##Handle player input	
	if Input.is_action_just_pressed("smash") && not smash_used:
		smash_active = true
		smash_used = true
	
	##Setup ball speed for collision calcs
	if smash_active:
		velocity = vector.normalized() * speed * smash_speed_mult
	else:
		velocity = vector.normalized() * velocity.length()

	if not smash_active:
		if velocity.length() > speed:
			velocity *= smash_speed_decay
		if velocity.length() < speed:
			velocity = vector.normalized() * speed
	
	##Collion calcs
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
		
	if collision:		
		var body: Node2D = collision.get_collider()
		if body:
			if body.is_in_group("paddle"):
				var mod_angle: Vector2 = position.direction_to(body.position)
				vector = (vector.bounce(collision.get_normal()) + (mod_angle * -1)).normalized()
				smash_used = false
			elif body.is_in_group("brick"):
				points_scored.emit(body.value)
				body.queue_free()
				if not smash_active:
					vector = vector.bounce(collision.get_normal())
			else:
				vector = vector.bounce(collision.get_normal())
				smash_active = false
		
		ball_bounce_sfx.play()
		
		##Prevent bug where ball gets squished by paddle and has it's rotation permanently offset
		rotation = 0	

func is_out_of_bounds(sprite_size: Vector2, window_size: Vector2, texture_scale: Vector2) -> bool:
	var margin: float = (32) * $BallSprite.scale.x
	if position.y >= window_size.y +  margin:
		return true
	else:
		return false

func setup_ball(init_pos: Vector2, init_vector: Vector2, init_speed: float) -> void:
	position = init_pos
	vector = init_vector
	speed = init_speed
