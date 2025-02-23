extends Enemy

var dir
var target_pos : Vector3

func _physics_process(delta):
	if player != null:
		var h_offset = -player.global_transform.basis.z * 8.0
		var v_offset = Vector3.UP * 1.0
		var base = player.global_transform.origin
		target_pos = base + h_offset# + v_offset

		var _dir : Vector3

		_dir = target_pos - global_transform.origin
		_dir.y = 0.0
		_dir = _dir.normalized()

		velocity.y -= 9.8 * delta
		var damp = pow(0.1, delta)
		velocity.x *= damp
		velocity.z *= damp
		if velocity.length() < max_speed:
			velocity += _dir * accel * delta
#		if check_step():
		velocity = move_and_slide(velocity, Vector3.UP)




