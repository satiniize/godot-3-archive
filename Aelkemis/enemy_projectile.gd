extends RigidBody2D

var damage: float

func _on_life_time_timeout():
	queue_free()


func _on_Area2D_body_entered(body):
	if body is entity:
		body.damage(damage)
