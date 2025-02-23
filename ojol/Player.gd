extends KinematicBody

var gravity : float = 9.8
var tire_friction : float = 4.0
var linear_velocity : Vector3
var angular_velocity : Vector3
var mass : float = 1200.0
var torque : float = 205.0
var redline = 7500.0
var idle = 1500.0
var wheel_diameter = 0.5
var final_drive = 4.1
var gear_ratios : Array = [
	3.626,
	2.188,
	1.541,
	1.213,
	1.000,
	0.767
]
var wheelbase = 2.57
var trackwidth = 1.52
var steering_angle = PI/12.0 # 30 degrees
var cur_rpm = 0.0
var cur_gear = 0
var max_turning_speed = 2.0 * PI / 3.0
var formula_steepness = 0.3 #never set to zero

#var cam_transform : Transform
var accel = Vector3.ZERO
var cam_base_transform : Transform
var cam_pos
var cam_basis

enum input{
	GAS,
	BRAKE,
	STEER,
}

enum transmission{
	MANUAL,
	AUTOMATIC
}

var input_dict = {
	input.GAS : 0.0,
	input.BRAKE : 0.0,
	input.STEER : 0.0
}

func _ready():
	cam_base_transform = $FollowCamera.transform
	$FollowCamera.set_as_toplevel(true)
	mass = 1190
	print("bruh")


func _process(delta):
	var scalar = 0.0005
	var offset : Vector3 = Vector3.FORWARD
	offset = offset.rotated(Vector3.UP, rand_range(0.0, 2*PI))
	offset = offset.rotated(Vector3.UP.cross(offset), rand_range(0.0, 2*PI))
	offset = offset * scalar * (linear_velocity.length())
	var target_transform = $DummyCamera.global_transform
	target_transform.origin += global_transform.basis.x * input_dict[input.STEER] * 2.5
	$FollowCamera.transform.origin += offset
	target_transform.basis.z = -linear_velocity.normalized()
	target_transform.basis.x = linear_velocity.cross(Vector3.UP).normalized()
	target_transform.basis.y = target_transform.basis.z.cross(target_transform.basis.x)
	$FollowCamera.global_transform = $FollowCamera.global_transform.interpolate_with(target_transform, 16.0 * delta)
	
	if Input.is_action_just_pressed("view_switch"):
		$FollowCamera.current = not $FollowCamera.current

func get_rpm(gear : int):
	return -60.0 * linear_velocity.dot(get_global_transform().basis.z) / (wheel_diameter / 2.0) * gear_ratios[gear] * final_drive / (2.0*PI)

func input(delta):
	var raw_steer_input = Input.get_action_strength("steer_right") - Input.get_action_strength("steer_left")
	var steer_lerp_strength = 4.0
	input_dict[input.GAS] = Input.get_action_strength("gas")
	input_dict[input.STEER] = lerp(input_dict[input.STEER], raw_steer_input, steer_lerp_strength * delta)
	input_dict[input.BRAKE] = Input.get_action_strength("brake")
	
	if cur_rpm >= redline and cur_gear < gear_ratios.size() - 1:
		cur_gear += 1
	if cur_gear > 0:
		if get_rpm(cur_gear - 1) < redline:
			cur_gear -= 1
#	if Input.is_action_just_pressed("gear_up") and cur_gear < gear_ratios.size() - 1:
#		cur_gear += 1
#	if Input.is_action_just_pressed("gear_down") and cur_gear > 0:
#		cur_gear -= 1

func _physics_process(delta):
	#todo list
	#do something to encourage drifting, currently more of a wmmt style handling
	
	input(delta)
	
	#move vehicle
	linear_velocity += accel / mass * delta
	linear_velocity = move_and_slide(linear_velocity, Vector3.UP)
	accel = Vector3.ZERO
	
	accel += Vector3.DOWN * gravity * mass
	
	var friction_force = mass*gravity*tire_friction
	var torque_force = 2*torque/wheel_diameter * gear_ratios[cur_gear]*final_drive*input_dict[input.GAS]
	var wheel_force = torque_force 
	if wheel_force > friction_force:
		wheel_force = friction_force
		#wheel spin
		
	$EngineSound.pitch_scale = max(cur_rpm / idle, 0.1)
	$SkidSound.unit_db = sqrt(abs(get_global_transform().basis.x.dot(linear_velocity.normalized()))) * 20.0 - 30.0
	
	#sentripetal force and turning
	var sentripetal_force_scale = 0.5
	var max_sentripetal_force = friction_force
	if input_dict[input.STEER] != 0.0:
		var turning_radius = tan(steering_angle * input_dict[input.STEER])
		var lean_strength = 0.5
		var lean_angle = atan(linear_velocity.length_squared() / gravity / (wheelbase / turning_radius)) * lean_strength
		var basis = Basis.IDENTITY.rotated(Vector3.UP, PI)
		$motor.transform.basis = basis.rotated(Vector3.FORWARD, lean_angle)
		var sentripetal_force = mass * linear_velocity.length_squared() / (wheelbase / turning_radius) * sentripetal_force_scale
		sentripetal_force = min(abs(sentripetal_force), max_sentripetal_force) * sign(sentripetal_force)
		angular_velocity.y = -linear_velocity.length() / (wheelbase / tan(steering_angle * input_dict[input.STEER]))
		accel += get_global_transform().basis.x * sentripetal_force
	
	#engine force
	if cur_rpm < redline:
		accel += (wheel_force * -get_global_transform().basis.z)
	
	#tire lateral force
	accel += -friction_force * get_global_transform().basis.x * linear_velocity.normalized().dot(get_global_transform().basis.x)
	
	#braking
	accel += -friction_force * get_global_transform().basis.z * linear_velocity.normalized().dot(get_global_transform().basis.z) * input_dict[input.BRAKE] * 0.2
#	cur_rpm = -60.0 * linear_velocity.dot(get_global_transform().basis.z) / (wheel_diameter / 2.0) * gear_ratios[cur_gear] * final_drive / (2.0*PI)
	cur_rpm = get_rpm(cur_gear)
	
	#rotate vehicle
	rotate(Vector3.UP, angular_velocity.y * delta)
	
	#discourage wall riding
	if is_on_wall():
		linear_velocity *= pow(0.01, delta)

	$TireSmoke.emitting = abs(linear_velocity.normalized().dot(get_global_transform().basis.x)) > 0.08 and is_on_floor()
