extends Weapon


func primary(player, space_state):
	var cam_dir = player.cam.global_transform.basis.z
	player.velocity += (-cam_dir + Vector3.UP).normalized() * world_recoil
#	var cam_origin = player.cam.global_transform.origin
#	for i in range(bullet_count):
#		var spread_dir : Vector3 = -cam_dir
#		spread_dir = spread_dir.rotated(player.cam.global_transform.basis.x, rand_range(0.0, spread))
#		spread_dir = spread_dir.rotated(cam_dir, rand_range(0.0, 2*PI))
#		var result = space_state.intersect_ray(cam_origin, cam_origin + spread_dir * 256.0, [player])
#		if result:
#			var collision_point = result["position"]
#			var collision_normal = result["normal"]
#			var bullet_hole_instance = load("res://bullet_hole.tscn").instance()
#			result["collider"].add_child(bullet_hole_instance)
#			bullet_hole_instance.global_transform.origin = collision_point + collision_normal * 0.001
#			bullet_hole_instance.global_transform.basis.z = collision_normal.normalized()
#			bullet_hole_instance.global_transform.basis.x = cam_dir.cross(collision_normal).normalized()
#			bullet_hole_instance.global_transform.basis.y = bullet_hole_instance.global_transform.basis.z.cross(bullet_hole_instance.global_transform.basis.x).normalized()
#	player.recoil.x += aim_recoil
