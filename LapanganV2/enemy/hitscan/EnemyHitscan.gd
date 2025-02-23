extends Enemy

var seek_duration: = 4.0
var attack_duration: = 2.0
var state_deviation: = 0.5
var is_attacking: = false
var offset: = Vector3(0.0, 0.8, 0.0)
func _ready():
	$SeekDuration.start(seek_duration + rand_range(-state_deviation, state_deviation))
	max_speed_sprint = 3.0
	
func handle_state(delta: float):
	match current_mode:
		Modes.SEEK:
			if $SeekDuration.is_stopped():
				$AnimationPlayer.play("Attack")
#				$Cooldown.start(attack_duration + rand_range(-state_deviation, state_deviation))
				handle_look((player.global_transform.origin - global_transform.origin).normalized())
				$AudioStreamPlayer3D.pitch_scale = rand_range(0.8, 1.2)
				$AudioStreamPlayer3D.play()
				current_mode = Modes.ATTACK
				$LookGroup.look_at(player.global_transform.origin, Vector3.UP)
			else:
				handle_path_find(player.global_transform.origin)
				handle_look(accel_dir)
		Modes.CAMP:
			pass
		Modes.ATTACK:
			accel_dir = Vector3.ZERO
#			var prev_rot_y = rotation.y
#			var prev_transform = global_transform
#			handle_look((player.global_transform.origin - global_transform.origin).normalized())
#			global_transform = prev_transform.interpolate_with(global_transform, delta * 4.0)
			var look_group_prev_transform = $LookGroup.global_transform
			$LookGroup.look_at(player.global_transform.origin + offset, Vector3.UP)
			$LookGroup.global_transform = look_group_prev_transform.interpolate_with($LookGroup.global_transform, delta * 4.0)
#			rotation.y = float_interpolate(prev_rot_y, rotation.y, delta * 4.0)
#			rotation.y = (prev_rot_y + rotation.y) / 2.0
			if $LookGroup/RayCast.is_colliding() and $LookGroup/Spatial.visible:
				($LookGroup/RayCast.get_collider() as LivingBody).damage(delta * 25.0)
			if !$AnimationPlayer.is_playing():
				current_mode = Modes.SEEK
				$SeekDuration.start(attack_duration + rand_range(-state_deviation, state_deviation))

func _on_Cooldown_timeout():
	pass # Replace with function body.
