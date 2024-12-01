extends Node2D

func _ready() -> void:
	$Particles.restart()

func _on_particles_finished() -> void:
	queue_free()
