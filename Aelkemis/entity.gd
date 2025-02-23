extends KinematicBody2D

class_name entity

var velocity: Vector2
var gravity: float = 400.0
var speed: float = 100.0
export(float) var health_stat = 20.0
onready var health: float = health_stat

func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2.UP)

func damage(value: float):
	health -= value
	if health <= 0.0:
		die()

func die():
	queue_free()
