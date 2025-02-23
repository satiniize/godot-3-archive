extends RigidBody

func _ready():
	var speed_range: = 10.0
	angular_velocity.x = rand_range(-speed_range, speed_range)
	angular_velocity.y = rand_range(-speed_range, speed_range)
	angular_velocity.z = rand_range(-speed_range, speed_range)
	$ExplodeTime.wait_time = ($Particles.lifetime)

func _on_Lifetime_timeout():
	$OmniLight.show()
	$MeshInstance.hide()
	linear_velocity = Vector3.ZERO
	gravity_scale = 0.0
	$Particles.restart()
	$Particles2.restart()
	for i in $Area.get_overlapping_bodies():
		if i is LivingBody:
			i.damage(33.0)
	$ExplodeTime.start()

func _on_ExplodeTime_timeout():
	queue_free()
