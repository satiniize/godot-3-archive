extends Node2D

var leg_L_global_target: Vector2 = Vector2.ZERO
var leg_R_global_target: Vector2 = Vector2.ZERO
var body_global_target: float
var foot_L_normal: Vector2
var foot_R_normal: Vector2
var offset: Vector2 = Vector2(10.0, 0.0)
var middle_point: Vector2
var step_length = 32.0
var step_normal: Vector2
var limb_speed: float
var step_found: bool

func _ready():
	$step_cast_F.add_exception(get_parent())
	$step_cast_M.add_exception(get_parent())
	$step_cast_N.add_exception(get_parent())
#
#func _draw():
#	draw_circle(Vector2.ZERO, 2.5, Color.red)
#	draw_circle(leg_L_global_target - global_position, 2.5, Color.red)
#	draw_circle(leg_R_global_target - global_position, 2.5, Color.red)
#	draw_circle($arm_L.position, 2.5, Color.red)
#	draw_circle($arm_R.position, 2.5, Color.red)
#	draw_line(Vector2(0.0, 64.0), Vector2(0.0, -32.0), Color.red, 2.5)
#
func _physics_process(delta):
	
	update()
	$arm_L.position.x = ($leg_R.position.x - $leg_L.position.x) / 2.0# * min(abs(get_parent().velocity.x) / 8.0, 1.0)
#	$arm_R.position.x = ($leg_L.position.x - $leg_R.position.x) / 2.0 #* min(abs(get_parent().velocity.x) / 8.0, 1.0)
	$arm_R.global_position = get_global_mouse_position()
	move_step_casts(3.0 / 8.0)
	move_point(delta)
	if (max(leg_L_global_target.x, leg_R_global_target.x) - global_position.x < 0.0 or
		min(leg_L_global_target.x, leg_R_global_target.x) - global_position.x > 0.0):
		step()
#	$body.position.y = sin((min(leg_L_global_target.x, leg_R_global_target.x) - global_position.x) / 8) * 2.0
func move_point(delta: float):
	$leg_L.global_position += (leg_L_global_target - $leg_L.global_position).normalized() * (get_parent().velocity.length() if (leg_L_global_target - $leg_L.global_position).length() - get_parent().velocity.length() < 0.0 else (leg_L_global_target - $leg_L.global_position).length()) * delta * 2.0
	$leg_R.global_position += (leg_R_global_target - $leg_R.global_position).normalized() * (get_parent().velocity.length() if (leg_R_global_target - $leg_R.global_position).length() - get_parent().velocity.length() < 0.0 else (leg_R_global_target - $leg_R.global_position).length()) * delta * 2.0
#	$body.global_position += (body_global_target - $body.global_position).normalized() * (get_parent().velocity.length() if (leg_R_global_target - $leg_R.global_position).length() - get_parent().velocity.length() < 0.0 else (leg_R_global_target - $leg_R.global_position).length()) * delta * 2.0

func step():
	var next_step = foot_safespot()
	if leg_L_global_target * get_parent().velocity.normalized().x < leg_R_global_target * get_parent().velocity.normalized():
		foot_L_normal = next_step.get_collision_normal()
		leg_L_global_target = next_step.get_collision_point() + foot_L_normal * 7.0
	else:
		foot_R_normal = next_step.get_collision_normal()
		leg_R_global_target = next_step.get_collision_point() + foot_R_normal * 7.0

func foot_safespot():
	var step_array = [$step_cast_F, $step_cast_M, $step_cast_N]
	var clauses: Array = []
#	step_found = false
	for i in range(0, 2):
		clauses.append(step_array[i].get_collision_point().y == step_array[i + 1].get_collision_point().y)
#		step_found = step_found or step_array[i].is_colliding()
	if clauses[0] and clauses[1]:
		return step_array[1]
	elif clauses[0]:
		return step_array[0]
	elif clauses[1]:
		return step_array[2]
	else:
		return step_array[1]

func move_step_casts(spacing_percentage: float):
	var multiplier: = (clamp(get_parent().velocity.x / 10.0, -1.0, 1.0))
	$step_cast_F.position.x = step_length * 1.0 * multiplier
	$step_cast_M.position.x = step_length * (1.0 - spacing_percentage) * multiplier
	$step_cast_N.position.x = step_length * (1.0 - spacing_percentage * 2.0) * multiplier
