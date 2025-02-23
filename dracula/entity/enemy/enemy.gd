extends Entity

class_name Enemy

var asleep : bool = true
var player : Node
var max_speed = 10.0
var accel = 64.0

func check_step():
	var space_state = get_world().direct_space_state
	var pos = global_transform.origin
	var v_offset = Vector3.UP * 1.0
	var h_offset = velocity.normalized()
	var step_tolerance = 0.5
	var result = space_state.intersect_ray(pos + h_offset + v_offset, pos + h_offset + step_tolerance * Vector3.DOWN, [self])
	if result:
		return true
	else:
		false
