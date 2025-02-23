class_name MovementBody
extends KinematicBody

var velocity := Vector3.ZERO
var accel_dir := Vector3.ZERO
var accel := 20.0
var max_speed_sprint := 4.0
var max_speed_crouch := 2.0
var max_speed_run := 6.0
var max_speed_air := 1.0
var stop_speed := 3.0
var forward_move := 4.0
var side_move := 3.0
var jump_force := 3.0
var stamina_amount := 1.0
var stamina := stamina_amount
var stamina_rate := 0.5
var friction := 4.0
var gravity := 9.8

func float_interpolate(_start: float, _end: float, _bias: float) -> float:
	return _start * (1.0 - _bias) + _end * _bias

func accel(_wish_dir: Vector3, _wish_speed: float, _max_speed: float, _delta: float) -> void: #Matches pmove.c pretty good
	_wish_speed = min(_wish_speed, _max_speed)
	var _current_speed = velocity.dot(_wish_dir)
	var _add_speed = _wish_speed - _current_speed
	if _add_speed < 0.0:
		return
	var _accel_speed = accel * _wish_speed * _delta
	_accel_speed = min(_accel_speed, _add_speed)
	velocity += _accel_speed * _wish_dir

func friction(delta: float) -> void: #Matches pmove.c pretty good
	var speed = velocity.length()
	var control = max(speed, stop_speed)
	var drop = control * friction * delta
	var new_speed = speed - drop
	new_speed = max(new_speed, 0.0)
	velocity = velocity.normalized() * new_speed

func handle_run(wish_crouch: bool, wish_run: bool, delta: float) -> float:
	if wish_crouch:
		return max_speed_crouch
	elif wish_run:
		stamina -= stamina_rate * delta
		stamina = clamp(stamina, 0.0, stamina_rate)
		if stamina > 0.0:
			return max_speed_run
		else:
			return max_speed_sprint
	else:
		stamina += stamina_rate * delta
		stamina = clamp(stamina, 0.0, stamina_rate)
		return max_speed_sprint

func handle_jump(_wish_jump: bool, _on_floor: bool, _on_ceiling: bool, _delta: float):
	if _wish_jump:
		if _on_floor:
			if velocity.y < jump_force:
				velocity.y = jump_force
			$JumpTimer.start()
		elif _on_ceiling:
			$JumpTimer.stop()
		elif !$JumpTimer.is_stopped():
			if velocity.y < jump_force:
				velocity.y = jump_force

func handle_move(accel_dir: Vector3, jump_input: bool, run_input: bool, crouch_input: bool, delta: float):
	velocity = move_and_slide(velocity, Vector3.UP)
	var on_floor = is_on_floor()
	var on_ceiling = is_on_ceiling()
	var movement_speed = handle_run(crouch_input, run_input, delta)
	if on_floor:
		accel(
			accel_dir,
			movement_speed,
			movement_speed,
			delta
			)
		friction(delta)
	else:
		accel(
			accel_dir,
			movement_speed,
			max_speed_air,
			delta
			)
	handle_jump(jump_input, on_floor, on_ceiling, delta)
	velocity.y -= gravity * delta
