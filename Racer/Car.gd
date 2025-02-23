extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(float) var spring_constant = -100000
export(float) var damp_rate = 0.5 
var tire_grip = 1.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	pass

func _integrate_forces(state):
	if Input.is_action_just_pressed("toggle_view"):
		$Camera.current = !$Camera.current
		$Camera2.current = !$Camera.current
	var forward_input = get_global_transform()[2] * -(Input.get_action_strength("throttle") - Input.get_action_strength("brake")) * Vector3(1.0, 0.0, 1.0)
	var side_input = Input.get_action_strength("steer_left") - Input.get_action_strength("steer_right")
	angular_velocity += side_input * Vector3(0.0, -0.2, 0.0) * get_steer_speed(linear_velocity.length(), 60) * get_global_transform()[2].dot(linear_velocity.normalized())
	var skid_force = get_global_transform()[2].rotated(Vector3.UP, PI/2.0).dot(linear_velocity.normalized()) * get_global_transform()[2].rotated(Vector3.UP, PI/2.0) * weight * tire_grip * -1.0
#	print(skid_force)
	add_central_force(forward_input * 80000)
	add_central_force(skid_force)
	add_force(calculate_spring_force($Suspension/Spring1), $Suspension/Spring1.global_transform.origin - global_transform.origin)
	add_force(calculate_spring_force($Suspension/Spring2), $Suspension/Spring2.global_transform.origin - global_transform.origin)
	add_force(calculate_spring_force($Suspension/Spring3), $Suspension/Spring3.global_transform.origin - global_transform.origin)
	add_force(calculate_spring_force($Suspension/Spring4), $Suspension/Spring4.global_transform.origin - global_transform.origin)
	$Label.text = str(linear_velocity.length())
	$MeshInstance1.global_transform.origin = $Suspension/Spring1.get_collision_point()
	$MeshInstance2.global_transform.origin = $Suspension/Spring2.get_collision_point()
	$MeshInstance3.global_transform.origin = $Suspension/Spring3.get_collision_point()
	$MeshInstance4.global_transform.origin = $Suspension/Spring4.get_collision_point()

func calculate_spring_force(spring: RayCast):
	if spring.is_colliding():
		var collision_point = spring.get_collision_point()
		var spring_pos = spring.global_transform.origin
		var end_point = spring_pos + (collision_point - spring_pos).normalized() * spring.cast_to.length()
		var force = (end_point - collision_point) * spring_constant
#		print(force.y)
		return force
	return Vector3.ZERO

func get_steer_speed(current_speed: float, top_speed: float):#50
	var value = current_speed / top_speed
	return max(-pow(abs(value), 2.0) + abs(value), 0.0)
