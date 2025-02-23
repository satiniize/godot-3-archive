extends Enemy

var threshold: = 1.5

func _ready():
	max_speed_sprint = 5.0

func handle_state(delta: float):
	var distance = (player.global_transform.origin - global_transform.origin).length()
	if distance > threshold:
		current_mode = Modes.SEEK
	else:
		current_mode = Modes.ATTACK
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
