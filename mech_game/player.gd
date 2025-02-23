extends KinematicBody2D

var gravity = Vector2(0, 255)
var velocity: Vector2 = gravity
var accel: = 256.0
var decel: = 144.0
var walk_speed: = 64.0
var sprint_speed: = 128.0
var max_speed: = walk_speed
var accel_dir
var active_missile
export var missile: PackedScene

func _physics_process(delta):
	movement(delta)
	$Label.text = str(Performance.get_monitor(Performance.TIME_FPS))

#func _draw():
#	draw_line(Vector2.ZERO, 65 * (lowest_leg() - global_position).normalized(), Color.white, 3.0)
#	draw_line(Vector2.ZERO, get_global_mouse_position() - global_position, Color.white, 2.0)
#	draw_circle(lowest_leg() - global_position, 3.0, Color.red)
func movement(delta: float):
	update()
#	print(IP.get_local_addresses())
	var input_right = Input.get_action_strength("ui_right")
	var input_left = Input.get_action_strength("ui_left")
	accel_dir = (input_right - input_left) * Vector2.RIGHT
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if Input.is_action_pressed("sprint"):
		max_speed = sprint_speed
	else:
		max_speed = walk_speed
	
	if (velocity + accel_dir * accel * delta).abs().x < max_speed:
		velocity += accel_dir * accel * delta
	if (velocity).abs().x > max_speed or accel_dir.normalized().length() < 1.0:
		velocity.x -= velocity.normalized().x * decel * delta
	if active_missile != null:
		$camera.global_position = active_missile.global_position
	else:
		$camera.global_position = global_position
		if Input.is_action_just_pressed("ui_accept"):
			active_missile = missile.instance()
			get_parent().add_child(active_missile)
			active_missile.global_position = global_position
	if $feet_cast.is_colliding():
		velocity.y = (lowest_leg().y - (global_position.y + (40.0 if Input.is_action_pressed("ui_down") else 65.0) * pow( (lowest_leg() - global_position).normalized().y, 1.0) ) ) * max(abs(velocity.x) / 16.0, 2.0) ##higher power makes bob noticeable but stucks stairs
	else:
		velocity += gravity * delta

func lowest_leg():
	var leg_L = $targets.leg_L_global_target
	var leg_R = $targets.leg_R_global_target
	if max(leg_L.y, leg_R.y) == leg_L.y:
		return leg_L
	else:
		return leg_R
