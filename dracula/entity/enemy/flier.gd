extends Enemy

var dir
var target_pos_l : Vector3
var target_pos_r : Vector3

func _physics_process(delta):
	if player != null:
		var h_offset = player.global_transform.basis.x * 8.0
		var v_offset = Vector3.UP * 1.0
		var base = player.global_transform.origin
		target_pos_l = base - h_offset + v_offset
		target_pos_r = base + h_offset + v_offset
		var l_dist = (target_pos_l - global_transform.origin).length()
		var r_dist = (target_pos_r - global_transform.origin).length()
		var _dir : Vector3
		if l_dist < r_dist:
			_dir = target_pos_l - global_transform.origin
		else:
			_dir = target_pos_r - global_transform.origin
#		if _dir.length() > 8.0:
#			_dir = _dir.normalized()
#		else:
#			_dir = -_dir.normalized()
		_dir = _dir.normalized()
		velocity += _dir * 16.0 * delta
		var damp = pow(0.5, delta)
		velocity *= damp
		move_and_slide(velocity)


#		_dir = player.global_transform.origin - global_transform.origin
