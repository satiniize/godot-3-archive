extends Weapon

func primary(player, space_state, delta):
	var max_speed = 16.0
	var cam_dir = player.cam.global_transform.basis.z
	if player.velocity.dot(-cam_dir) < max_speed:
		player.velocity += -cam_dir

func secondary(player, space_state, delta):
	pass
