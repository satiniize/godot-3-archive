extends Weapon

#make this shit stun people so
#1 shoot
#2 self damage
#3 stun
#4 suck
#risk reward

func primary(player, space_state, delta):
	var cam_origin = player.cam.global_transform.origin
	var cam_dir = player.cam.global_transform.basis.z
	player.damage(10.0)
	var result = space_state.intersect_ray(cam_origin, cam_origin + cam_dir * -256.0, [player])
	if result:
		if result["collider"] is Entity:
			result["collider"].damage(100.0)
		else:
			var collision_point = result["position"]
			var collision_normal = result["normal"]
			var bullet_hole_instance = load("res://item/weapons/bullet_hole.tscn").instance()
			result["collider"].add_child(bullet_hole_instance)
			bullet_hole_instance.global_transform.origin = collision_point + collision_normal * 0.001
			bullet_hole_instance.global_transform.basis.z = collision_normal.normalized()
			bullet_hole_instance.global_transform.basis.x = cam_dir.cross(collision_normal).normalized()
			bullet_hole_instance.global_transform.basis.y = bullet_hole_instance.global_transform.basis.z.cross(bullet_hole_instance.global_transform.basis.x).normalized()
	player.velocity += cam_dir * world_recoil
	player.recoil.x += aim_recoil
