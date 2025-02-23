extends Item


func primary(player):
	var space_state = player.get_world_2d().direct_space_state
	var result = space_state.intersect_ray(player.global_position, player.global_position + player.aim_dir * 16.0, [player])
	if result:
		var target = result["collider"]
		target.damage(10)
