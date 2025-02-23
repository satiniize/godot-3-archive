extends Weapon

var has_shot = false
var cooldown = 0.5
#var cool_down_timer = cool_down_time

#func process(player, space_state, primary_input, secondary_input, delta) -> void:
#	if primary_input:
#		if not has_shot and cool_down_timer <= 0.0:
#			primary(player, space_state, delta)
#	elif secondary_input:
#		if not has_shot and cool_down_timer <= 0.0:
#			secondary(player, space_state, delta)
#	else:
#		has_shot = false
#	cool_down_timer -= delta
#	cool_down_timer = clamp(cool_down_timer, 0.0, 1.0)
#func shoot_bullet(dir):


#func spawn_bullet_hole(position, normal):
#	var collision_point = result["position"]
#	var collision_normal = result["normal"]
#	var bullet_hole_instance = load("res://bullet_hole.tscn").instance()
#	result["collider"].add_child(bullet_hole_instance)
#	bullet_hole_instance.global_transform.origin = collision_point + collision_normal * 0.001
#	bullet_hole_instance.global_transform.basis.z = collision_normal.normalized()
#	bullet_hole_instance.global_transform.basis.x = cam_dir.cross(collision_normal).normalized()
#	bullet_hole_instance.global_transform.basis.y = bullet_hole_instance.global_transform.basis.z.cross(bullet_hole_instance.global_transform.basis.x).normalized()

func primary(player, space_state, delta):
	if player.ammo[ItemDef.AmmoType.SHELL] > 0:
		var cam_origin = player.cam.global_transform.origin
		var cam_dir = player.cam.global_transform.basis.z
		for i in range(bullet_count):
			var spread_dir : Vector3 = -cam_dir
			spread_dir = spread_dir.rotated(player.cam.global_transform.basis.x, rand_range(0.0, spread))
			spread_dir = spread_dir.rotated(cam_dir, rand_range(0.0, 2*PI))
			var result = space_state.intersect_ray(cam_origin, cam_origin + spread_dir * 256.0, [player])
			if result:
				if result["collider"] is Entity:
					result["collider"].damage(10.0)
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
		player.screen_shake(screen_shake)
		player.viewmodel_target_transform.origin.z = aim_recoil
		player.ammo[ItemDef.AmmoType.SHELL] -= 1
		player.weapon_cooldown_timer = primary_cooldown
#		has_shot = true
#		cool_down_timer = cool_down_time

func secondary(player, space_state, delta):
	if player.ammo[ItemDef.AmmoType.SHELL] > 1:
		var cam_origin = player.cam.global_transform.origin
		var cam_dir = player.cam.global_transform.basis.z
		for i in range(bullet_count / 2):
			var spread_dir : Vector3 = -cam_dir
			spread_dir = spread_dir.rotated(player.cam.global_transform.basis.x, rand_range(0.0, spread))
			spread_dir = spread_dir.rotated(cam_dir, rand_range(0.0, 2*PI))
			var result = space_state.intersect_ray(cam_origin, cam_origin + spread_dir * 256.0, [player])
			if result:
				if result["collider"] is Entity:
					result["collider"].damage(10.0)
				else:
					var collision_point = result["position"]
					var collision_normal = result["normal"]
					var bullet_hole_instance = load("res://item/weapons/explosion.tscn").instance()
					result["collider"].add_child(bullet_hole_instance)
					bullet_hole_instance.global_transform.origin = collision_point + collision_normal * 0.001
					bullet_hole_instance.global_transform.basis.z = collision_normal.normalized()
					bullet_hole_instance.global_transform.basis.x = cam_dir.cross(collision_normal).normalized()
					bullet_hole_instance.global_transform.basis.y = bullet_hole_instance.global_transform.basis.z.cross(bullet_hole_instance.global_transform.basis.x).normalized()
					bullet_hole_instance.explode()
		player.velocity += cam_dir * world_recoil * 2.0
		player.recoil.x += aim_recoil * 2.0
		player.screen_shake(screen_shake)
		player.viewmodel_target_transform.origin.z = aim_recoil
		player.ammo[ItemDef.AmmoType.SHELL] -= 2
		player.weapon_cooldown_timer = secondary_cooldown
#		has_shot = true
#		cool_down_timer = cool_down_time
	else:
		primary(player, space_state, delta)
