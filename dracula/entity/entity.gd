extends KinematicBody

class_name Entity

var health = 100.0
var velocity : Vector3 = Vector3.ZERO

func damage(amount : float):
	health -= amount
	if health <= 0.0:
		die()
		
func die():
	queue_free()
