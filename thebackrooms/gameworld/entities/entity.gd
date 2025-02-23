class_name Entity

extends KinematicBody


var velocity = Vector3.ZERO
var base_health = 100.0
var health = base_health


func damage(damage : float):
	health -= damage
	if health <= 0.0:
		die()

func die():
	queue_free()
