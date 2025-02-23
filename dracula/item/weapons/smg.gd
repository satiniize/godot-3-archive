extends Weapon

var grenade = preload("res://item/weapons/grenade.tscn")
var cooldown = 0.1
var rpm = 600

func secondary(player, space_state, delta):
	if player.ammo[ItemDef.AmmoType.GRENADE] > 1:
		var cam_origin = player.cam.global_transform.origin
		var cam_dir = player.cam.global_transform.basis.z
		var grenade_instance = grenade.instance()
		player.get_tree().current_scene.add_child(grenade_instance)
		grenade_instance.launch(cam_origin, -cam_dir)
		player.recoil.x += aim_recoil * 4.0
		player.weapon_cooldown_timer = secondary_cooldown
		player.ammo[ItemDef.AmmoType.GRENADE] -= 1

func primary(player, space_state, delta):
	if player.ammo[ItemDef.AmmoType.LIGHT] > 1:
		var cam_origin = player.cam.global_transform.origin
		var cam_dir = player.cam.global_transform.basis.z
		var result = space_state.intersect_ray(cam_origin, cam_origin + cam_dir * -256.0, [player])
		if result:
			if result["collider"] is Entity:
				result["collider"].damage(50.0)
			else:
				var collision_point = result["position"]
				var collision_normal = result["normal"]
				var bullet_hole_instance = load("res://item/weapons/bullet_hole.tscn").instance()
				result["collider"].add_child(bullet_hole_instance)
				bullet_hole_instance.global_transform.origin = collision_point + collision_normal * 0.001
				bullet_hole_instance.global_transform.basis.z = collision_normal.normalized()
				bullet_hole_instance.global_transform.basis.x = cam_dir.cross(collision_normal).normalized()
				bullet_hole_instance.global_transform.basis.y = bullet_hole_instance.global_transform.basis.z.cross(bullet_hole_instance.global_transform.basis.x).normalized()
		player.recoil.x += aim_recoil * 2.0
		player.weapon_cooldown_timer = primary_cooldown
		player.viewmodel_target_transform.origin.z = aim_recoil * 4.0
		player.ammo[ItemDef.AmmoType.LIGHT] -= 1
#	cooldown -= delta
#		cooldown += 1.0 / (rpm / 60.0)
#	if cooldown <= 0.0:
