class_name Player


extends LivingBody


var sensitivity: float = 20.8
var accel = 32.0
var damp = 0.1


func dpi2rad(distance: float, dpi: int):
	return distance * 2.54 * 2 * PI / (float(dpi) * sensitivity)


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		var _relative = event.relative
		var _rot_axis = Vector3(-_relative.y, -_relative.x, 0.0)
		_rot_axis = _rot_axis.normalized()
		rotate_object_local(
			_rot_axis, 
			dpi2rad(_relative.length(), 1000)
		)


func handle_move(delta : float):
	var accel_dir := Vector3.ZERO
	var basis := get_global_transform().basis
	if Input.is_action_pressed("move_backward"):
		accel_dir += basis.z
	if Input.is_action_pressed("move_forward"):
		accel_dir += -basis.z
	if Input.is_action_pressed("move_left"):
		accel_dir += -basis.x
	if Input.is_action_pressed("move_right"):
		accel_dir += basis.x
	if Input.is_action_pressed("move_up"):
		accel_dir += basis.y
	if Input.is_action_pressed("move_down"):
		accel_dir += -basis.y
	if Input.is_action_pressed("rotate_cw"):
		rotate_object_local(Vector3.FORWARD, delta)
	if Input.is_action_pressed("rotate_ccw"):
		rotate_object_local(Vector3.FORWARD, -delta)
	accel_dir = accel_dir.normalized()
	velocity += accel_dir * accel * delta
#	velocity -= get_global_transform().origin.normalized() * 9.8 * delta
	velocity *= pow(damp, delta)
	velocity = move_and_slide(velocity)


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	handle_move(delta)

