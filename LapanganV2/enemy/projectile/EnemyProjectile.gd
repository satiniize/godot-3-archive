extends Enemy

func handle_state(delta: float):
	match current_mode:
		Modes.SEEK:
			handle_path_find(player.global_transform.origin)
			handle_look(accel_dir)
		Modes.CAMP:
			pass
		Modes.ATTACK:
			$RayCast.look_at(player.global_transform.origin, Vector3.UP)
			if $RayCast.is_colliding() and !$AnimationPlayer.is_playing():
				print($RayCast.get_collider())
				if $RayCast.get_collider() == player:
					$AnimationPlayer.play("Attack")
					$RayCast.get_collider().damage(20.0)

#func predict_body_future_old(body: MovementBody):
#	if body.velocity.length() > 0.0:
#		var predicted_pos: Vector3
#		var body_offset = 	sqrt( (body.global_transform.origin - global_transform.origin).length() / 
#							(pow(projectile_speed / body.velocity.length(), 2.0) - 1.0))
#		predicted_pos = body.global_transform.origin + body.velocity.normalized() * body_offset
#		return predicted_pos
