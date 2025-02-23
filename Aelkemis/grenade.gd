extends RigidBody2D

func _on_life_time_timeout():
	for i in $explosion.get_overlapping_bodies():
		if i is entity:
			i.damage(10.0)
			i.velocity += (i.global_position - global_position).normalized() * 500.0
	queue_free()
