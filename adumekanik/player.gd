extends KinematicBody

onready var cam_group = get_node("CamGroup")

var mouse_sensitivity = -0.01

var accel_dir
var velocity: Vector3

func _input(event):
	if event is InputEventMouseMotion:
		cam_group.rotation.x += (event.relative.y * mouse_sensitivity)
		cam_group.rotation.y += (event.relative.x * mouse_sensitivity)
		cam_group.rotation.x = clamp(cam_group.rotation.x, -3 * PI/8, -PI/8)

func _physics_process(delta):
	movement(delta)

func movement(delta):
	var lateral_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var depth_input = Input.get_action_strength("move_up") - Input.get_action_strength("move_down")
	var lateral_dir = (-cam_group.transform.basis.z).cross(Vector3.UP).normalized()
	var depth_dir = lateral_dir.cross(-Vector3.UP)
	accel_dir = lateral_dir*lateral_input + depth_dir*depth_input
	accel_dir = accel_dir.normalized()
	velocity.x = accel_dir.x * 10.0
	velocity.z = accel_dir.z * 10.0
	velocity.y -= 9.8 * delta
	velocity = move_and_slide(velocity)
