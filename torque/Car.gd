extends RigidBody

var gravity : float = 9.8
var tire_friction : float = 2.0
var velocity : Vector3

#var mass : float = 1190.0
var torque : float = 205.0
var redline = 7500.0
var idle = 1500.0
var wheel_diameter = 0.5
var final_drive = 4.1
var gear_ratios : Array = [
	3.626,
	2.188,
	1.541,
	1.213
]
var wheelbase = 2.57
var trackwidth = 1.52
var steering_angle = PI/4.0 # 30 degrees
var cur_rpm = 0.0
var cur_gear = 0
var cur_steer = 0.0
var cur_gas = 0.0
var max_turning_speed = 2.0 * PI / 3.0
var formula_steepness = 0.3 #never set to zero

var cam_transform : Transform

func _ready():
	cam_transform = $ClippedCamera.transform
	mass = 1190

#func _physics_process(delta):

	
	

#	velocity += wheel_force/mass * delta * -get_global_transform().basis.z

#	velocity -= friction_force/mass * delta * get_global_transform().basis.x * velocity.normalized().dot(get_global_transform().basis.x)
#	velocity -= friction_force/mass * delta * get_global_transform().basis.z * velocity.normalized().dot(get_global_transform().basis.z) * brake_input
func _process(delta):
	var scalar = 0.001
	var offset : Vector3 = Vector3.FORWARD
	offset = offset.rotated(Vector3.UP, rand_range(0.0, 2*PI))
	offset = offset.rotated(Vector3.UP.cross(offset), rand_range(0.0, 2*PI))
	offset = offset * scalar * (linear_velocity.length())
#	var offset : Vector3 = Vector3.UP
#	offset.rotated(Vector3.RIGHT, rand_range(-PI, PI))
	$ClippedCamera.transform.origin = cam_transform.origin + offset
	$ClippedCamera.transform = $ClippedCamera.transform.interpolate_with(cam_transform, delta)
	
func _integrate_forces(state):
	#todo list
	#convert to kinematic body so its consistent
	#add sentrifugal forces to improve handling
	var max_speed_gear = 1000.0
	
	var gas_input = Input.get_action_strength("gas")
	var steer_input = Input.get_action_strength("steer_right") - Input.get_action_strength("steer_left")
	var brake_input = Input.get_action_strength("brake")
	
	if Input.is_action_just_pressed("gear_up") and cur_gear < gear_ratios.size() - 1:
		cur_gear += 1
	if Input.is_action_just_pressed("gear_down") and cur_gear > 0:
		cur_gear -= 1
	var friction_force = mass*gravity*tire_friction
	var torque_force = 2*torque/wheel_diameter * gear_ratios[cur_gear] * final_drive * gas_input
	var wheel_force = min(friction_force, torque_force) 
	#when torque force > friction force:
		#wheel spin
	var sentripetal_force = 0
	
	cur_steer = lerp(cur_steer, steer_input, 0.05)
	$AudioStreamPlayer3D.pitch_scale = cur_rpm / idle
	$AudioStreamPlayer3D2.unit_db = sqrt(abs(get_global_transform().basis.x.dot(linear_velocity.normalized()))) * 40.0 - 20.0
	if steer_input != 0.0:
		sentripetal_force = mass * linear_velocity.length_squared() / (wheelbase / tan(deg2rad(steering_angle * steer_input)))
	var target_rot_speed = 0.0
	if cur_steer != 0.0:
		target_rot_speed = -linear_velocity.length() / (wheelbase / tan(steering_angle * cur_steer))
	angular_velocity.y = min(target_rot_speed, max_turning_speed)
#	add_torque(Vector3.UP * min(turning_torque, friction_force) * wheelbase)
	
	# rear tires
#	add_torque(Vector3.UP * friction_force / 2.0 * wheelbase / 2.0 * sign(-angular_velocity.y))
	
	if cur_rpm < redline:
		add_central_force(wheel_force * -get_global_transform().basis.z)
	
	add_central_force(-friction_force * get_global_transform().basis.x * linear_velocity.normalized().dot(get_global_transform().basis.x))
	add_central_force(-friction_force * get_global_transform().basis.z * linear_velocity.normalized().dot(get_global_transform().basis.z) * brake_input)
	
	cur_rpm = -60.0 * linear_velocity.dot(get_global_transform().basis.z) / (wheel_diameter / 2.0) * gear_ratios[cur_gear] * final_drive / (2.0*PI)
	print(cur_rpm)
	if $RayCast.is_colliding():
		add_central_force(Vector3.UP * 10000.0)
#	velocity = move_and_slide(velocity)
	

#	var rpm = 60*2*velocity.length()/wheel_diameter*final_drive*gear_ratios[cur_gear]
#	if rpm < max_rpm:
#	cur_rpm = 60*2*velocity.length()/wheel_diameter*final_drive*gear_ratios[cur_gear]
#func torque_formula(x):
#	return (x + 2*formula_steepness) / (1 + 2*formula_steepness)
#
#func torqueatrpm(_rpm : float):
#	var formula_result = torque_formula(cur_rpm / max_rpm)
#	var _torque = 1.0 - formula_result
#	_torque *= formula_result*formula_result
#	_torque *= 27.0 / 4.0
#	return _torque * torque
