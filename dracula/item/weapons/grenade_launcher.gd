extends Weapon

var grenade = preload("res://item/weapons/grenade.tscn")

func primary(player, space_state, delta):
	var cam_origin = player.cam.global_transform.origin
	var cam_dir = player.cam.global_transform.basis.z
	var grenade_instance = grenade.instance()
	player.get_tree().current_scene.add_child(grenade_instance)
	grenade_instance.launch(cam_origin, -cam_dir)
	player.recoil.x += aim_recoil
	player.weapon_cooldown_timer = primary_cooldown
#	grenade_instance.global_transform.origin = cam_origin
#	for i in range(bullet_count):
#		var spread_dir : Vector3 = -cam_dir
#		spread_dir = spread_dir.rotated(player.cam.global_transform.basis.x, rand_range(0.0, spread))
#		spread_dir = spread_dir.rotated(cam_dir, rand_range(0.0, 2*PI))
#		var result = space_state.intersect_ray(cam_origin, cam_origin + spread_dir * 256.0, [player])
#		if result:
#			if result["collider"] is Entity:
#				result["collider"].damage(10.0)
#			else:
#				var collision_point = result["position"]
#				var collision_normal = result["normal"]
#				var bullet_hole_instance = load("res://bullet_hole.tscn").instance()
#				result["collider"].add_child(bullet_hole_instance)
#				bullet_hole_instance.global_transform.origin = collision_point + collision_normal * 0.001
#				bullet_hole_instance.global_transform.basis.z = collision_normal.normalized()
#				bullet_hole_instance.global_transform.basis.x = cam_dir.cross(collision_normal).normalized()
#				bullet_hole_instance.global_transform.basis.y = bullet_hole_instance.global_transform.basis.z.cross(bullet_hole_instance.global_transform.basis.x).normalized()
#	player.velocity += cam_dir * world_recoil
#	player.recoil.x += aim_recoil
