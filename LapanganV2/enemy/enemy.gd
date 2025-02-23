class_name Enemy
extends LivingBody

export(NodePath) var player_cast_path
onready var player_cast = get_node(player_cast_path)
export(NodePath) var nav_node_path
onready var nav_node: Navigation = get_node(nav_node_path)
export(NodePath) var player_path
onready var player: KinematicBody = get_node(player_path)
#var player: LivingBody
export(NodePath) var camp_points_path
onready var camp_points: Spatial = get_node(camp_points_path)
#onready var look_group = get_node("LookGroup")
var target_pos: Vector3
#var campingPos: Vector3
var path_to_target: PoolVector3Array
#var enemyVelocity: Vector3 = Vector3.ZERO
#var strafeDir: = 1
#var enemyAccuracy = 0.8
enum Modes{SEEK, CAMP, ATTACK}
var current_mode = Modes.SEEK
#var projectile_speed := 10.0
var wish_jump = false
var player_last_visible: Vector3
#var preffered_distance: Array = []
var dormant = true
#func _ready():
#	$petani.get_node("AnimationPlayer").play("ArmatureAction")
#	max_speed_sprint = 3.0
#	preffered_distance.append(rand_range(2.0, 7.0))
#	preffered_distance.append(rand_range(7.0, 15.0))

#func _ready():
#	player = Global.player

func get_nearest_position(point: Vector3, camp_points: Node):
	var output = camp_points.get_child(0).get_global_transform().origin
	var distance = (camp_points.get_child(0).get_global_transform().origin - get_global_transform().origin).length()
	for node in camp_points.get_children():
		var compare_distance = (node.get_global_transform().origin - get_global_transform().origin).length()
		if compare_distance < distance:
			distance = compare_distance
			output = node.get_global_transform().origin
	return output

func handle_state(delta: float):
	pass
	
#func handle_state():
#	match current_mode:
#		Modes.SEEK:
#			handle_path_find(player.global_transform.origin)
#			handle_look(accel_dir)
#		Modes.CAMP:
#			pass
#		Modes.ATTACK:
#			pass

#func handle_state():
#	match current_mode:
#		Modes.SEEK:
#			if !look_group.player_is_visible:
#				handle_path_find(player.global_transform.origin)
#				handle_look(accel_dir)
#			else:
#				current_mode = Modes.SHOOT
#		Modes.CAMP:
#			pass
#		Modes.SHOOT:
#			accel_dir = Vector3.ZERO
#			if look_group.player_is_visible:
#				if $ShootTimer.is_stopped():
#					$ShootTimer.start(rand_range(1.0, 2.0))
#			else:
#				current_mode = Modes.SEEK
#		Modes.WANDER:
#			handle_path_find(global_transform.origin + velocity.rotated(Vector3.UP, rand_range(-PI/4.0, PI/4.0)) + Vector3(rand_range(-1.0, 1.0), 0.0, rand_range(-1.0, 1.0)))
#			handle_look(velocity.normalized())

#func handle_shoot():
#	var offset := Vector3(0.0, 1.0, 0.0)
#	var projectile_instance = projectile.instance()
#	get_tree().root.get_child(0).add_child(projectile_instance)
#	var target: Vector3 = predict_body_future(player)
#	var self_pos = global_transform.origin
#	var shoot_dir: Vector3 = (target - self_pos)
#	var distance = shoot_dir.length()
#	shoot_dir = shoot_dir.normalized()
#	var rad_spread := deg2rad(spread)
#	shoot_dir = shoot_dir.rotated(Vector3.UP, rand_range(-rad_spread, rad_spread))
#	projectile_instance.global_transform.origin = global_transform.origin + offset
#	projectile_instance.linear_velocity = shoot_dir * projectile_speed
#	projectile_instance.get_node("Lifetime").wait_time = distance / projectile_speed
#	projectile_instance.get_node("Lifetime").start()
#	get_parent().get_node("MeshInstance").global_transform.origin = predict_body_future(player)
#	handle_look(shoot_dir)

func handle_path_find(target_pos):
	var deadzone = 1.0
#	path_to_target = nav_node.get_simple_path(get_global_transform().origin, nav_node.get_closest_point(target_pos))
	path_to_target = nav_node.get_simple_path(get_global_transform().origin, target_pos)
	if path_to_target.size() > 1:
		if (get_global_transform().origin - target_pos).length() > deadzone:
			var wishSpeed = (path_to_target[1] - get_global_transform().origin)
			wishSpeed.y = 0.0
			accel_dir = wishSpeed.normalized()
			wish_jump = is_on_wall()
		else:
			accel_dir = Vector3.ZERO

func handle_look(look_dir):
	if look_dir.normalized().length() > 0.0:
		rotation.y = -Vector2.ZERO.angle_to_point(Vector2(look_dir.x, look_dir.z)) + PI/2.0

func _physics_process(delta):
	player = Global.player
#	nav_node = Global.navigation
#	player = get_node(MainScene.player_path)
	if !dormant:
		handle_move(accel_dir, wish_jump, false, false, delta)
		handle_state(delta)

#func _on_changeStrafeTimer_timeout():
#	if randi() % 2 == 0:
#		strafeDir = 1
#	else:
#		strafeDir = -1
#	$changeStrafeTimer.wait_time = rand_range(0.0, 1.0)
#
#func _on_ShootTimer_timeout():
#	handle_shoot()

#func predict_body_future_old(body: MovementBody):
#	if body.velocity.length() > 0.0:
#		var predicted_pos: Vector3
#		var body_offset = 	sqrt( (body.global_transform.origin - global_transform.origin).length() / 
#							(pow(projectile_speed / body.velocity.length(), 2.0) - 1.0))
#		predicted_pos = body.global_transform.origin + body.velocity.normalized() * body_offset
#		return predicted_pos

#func predict_body_future(body: MovementBody):
#	var self_pos = vec3_to_vec2(global_transform.origin)
#	var body_pos = vec3_to_vec2(body.global_transform.origin)
#	var diff = body_pos - self_pos
#	var body_vel = vec3_to_vec2(body.velocity)
#	var slope1 = atan(get_slope(diff))
#	var slope2 = atan(get_slope(body_vel))
#	var angle = slope1 - slope2
#	var theta
#	var body_speed = body.velocity.length()
#	var ratio = projectile_speed / body_speed
#	var distance = (global_transform.origin - body.global_transform.origin).length()
#	var body_move_distance = (distance /
#						sqrt(1.0 + ratio*ratio - 2.0*ratio*cos(angle))
#						)
#	var predicted_pos = body.global_transform.origin + body.velocity.normalized() * body_move_distance
#	return predicted_pos

#func get_slope(value: Vector2):
#	if value.x > 0.0:
#		return value.y / value.x
#	else:
#		return 0.0

func vec3_to_vec2(value: Vector3):
	return Vector2(value.x, value.z)

func handle_jump(_wish_jump: bool, _on_floor: bool, _on_ceiling: bool, _delta: float):
	if _wish_jump:
		if _on_floor:
			velocity.y = jump_force * 2.0
