extends Spatial

var radius : float = 4.0

func explode():
	$Fire.restart()
	$Smoke.restart()
	var params = PhysicsShapeQueryParameters.new()
	var shape = SphereShape.new()
	shape.radius = radius
	params.set_shape(shape)
	params.transform = global_transform
	var space_state = get_world().direct_space_state
	var results = space_state.intersect_shape(params)
	for result in results:
		var collider = result["collider"]
		if collider is Entity:
#			print("true")
			var distance = (collider.global_transform.origin - global_transform.origin)
			collider.damage(64.0 / max(distance.length(), 1.0))
			collider.velocity += 16.0 / max(distance.length(), 1.0) * distance.normalized()
			if collider is Player:
				collider.screen_shake(0.5 / max(distance.length(), 1.0))
	$AudioStreamPlayer3D.play()
