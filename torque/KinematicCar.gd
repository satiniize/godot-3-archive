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
var steering_angle = PI/6.0 # 30 degrees
var cur_rpm = 0.0
var cur_gear = 0
var cur_steer = 0.0
var cur_gas = 0.0
var max_turning_speed = 2.0 * PI / 3.0
var formula_steepness = 0.3 #never set to zero

var cam_transform : Transform

func _ready():
	cam_transform = $FollowCamera.transform
	mass = 1190


func _process(delta):
	var scalar = 0.0005
	var offset : Vector3 = Vector3.FORWARD
	offset = offset.rotated(Vector3.UP, rand_range(0.0, 2*PI))
	offset = offset.rotated(Vector3.UP.cross(offset), rand_range(0.0, 2*PI))
	offset = offset * scalar * (linear_velocity.length())
	$FollowCamera.transform.origin += offset
	$FollowCamera.transform = $FollowCamera.transform.interpolate_with(cam_transform, 8.0 * delta)
	if Input.is_action_just_pressed("view_switch"):
		$FollowCamera.current = not $FollowCamera.current
#		$BumperCamera.current = not $BumperCamera.current
	
func _physics_process(delta):
	#todo list
	#convert to kinematic body so its consistent = done
	#add sentrifugal forces to improve handling = done
	#do something to encourage drifting, currently more of a wmmt style handling
	var accel = Vector3.ZERO
	accel += Vector3.DOWN * gravity * mass
	var gas_input = Input.get_action_strength("gas")
	var steer_input = Input.get_action_strength("steer_right") - Input.get_action_strength("steer_left")
	var brake_input = Input.get_action_strength("brake")
	if Input.is_action_just_pressed("gear_up") and cur_gear < gear_ratios.size() - 1:
		cur_gear += 1
	if Input.is_action_just_pressed("gear_down") and cur_gear > 0:
		cur_gear -= 1
		
	var friction_force = mass*gravity*tire_friction
	var torque_force = 2*torque/wheel_diameter * gear_ratios[cur_gear]*final_drive*gas_input
	var wheel_force = min(friction_force, torque_force) 
	#when torque force > friction force:
		#wheel spin
	cur_steer = lerp(cur_steer, steer_input, 0.1)
	$EngineSound.pitch_scale = cur_rpm / idle
	$SkidSound.unit_db = sqrt(abs(get_global_transform().basis.x.dot(linear_velocity.normalized()))) * 40.0 - 20.0
	var target_rot_speed = 0.0
	var sentripetal_force_scale = 1.0
	var max_sentripetal_force = friction_force
	if cur_steer != 0.0:
		var sentripetal_force = mass * linear_velocity.length_squared() / (wheelbase / tan(steering_angle * cur_steer)) * sentripetal_force_scale
		sentripetal_force = min(abs(sentripetal_force), max_sentripetal_force) * sign(sentripetal_force)
		target_rot_speed = -linear_velocity.length() / (wheelbase / tan(steering_angle * cur_steer))
		accel += get_global_transform().basis.x * sentripetal_force
		print(accel.length())
#	angular_velocity.y = min(abs(target_rot_speed), max_turning_speed) * sign(target_rot_speed)
	angular_velocity.y = target_rot_speed
	if cur_rpm < redline:
		accel += (wheel_force * -get_global_transform().basis.z)
	accel += -friction_force * get_global_transform().basis.x * linear_velocity.normalized().dot(get_global_transform().basis.x)
	accel += -friction_force * get_global_transform().basis.z * linear_velocity.normalized().dot(get_global_transform().basis.z) * brake_input
	cur_rpm = -60.0 * linear_velocity.dot(get_global_transform().basis.z) / (wheel_diameter / 2.0) * gear_ratios[cur_gear] * final_drive / (2.0*PI)
	
	linear_velocity += accel / mass * delta
	linear_velocity = move_and_slide(linear_velocity, Vector3.UP)
#	move_and_collide(linear_velocity)
	rotate(Vector3.UP, angular_velocity.y * delta)
	if is_on_wall():
		linear_velocity *= pow(0.01, delta)
#		linear_velocity *= -1.0
