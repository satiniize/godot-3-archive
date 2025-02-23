class_name LivingBody
extends MovementBody

export(float) var health = 100.0

func damage(amount: float):
	health -= amount
	if health <= 0.0:
		queue_free()
