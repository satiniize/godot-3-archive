extends KinematicBody2D

var accel_dir: Vector2
var velocity: Vector2
var max_speed: float = 64.0
var simple_path: PoolVector2Array
var player_is_visible: bool = true
export(NodePath) var path_to_navigation
onready var navigation: Navigation2D = get_node(path_to_navigation)
export(NodePath) var path_to_patrol_path
onready var patrol_path: PathFollow2D = get_node(path_to_patrol_path)
enum States{PATROL, CHASE, RETURNTOPATROL}
var state = States.PATROL
var target_position: Vector2
var look_dir: Vector2

func _physics_process(delta):
	handle_state(delta)
	$RayCast2D.global_rotation = 0.0
	$RayCast2D.cast_to = (Global.player.global_position - global_position)
	print(look_dir.dot((Global.player.global_position - global_position).normalized()))

func handle_state(delta: float):
	match state:
		States.PATROL:
			velocity = Vector2.ZERO
			patrol_path.offset += max_speed * delta
			look_dir = (patrol_path.global_position - global_position).normalized()
			rotation = get_look_dir()
			global_position = patrol_path.global_position
			if visibility_check():
				target_position = Global.player.global_position
				state = States.CHASE
		States.CHASE:
			var threshold: float
			if visibility_check():
				threshold = 20.0
				target_position = Global.player.global_position
			else:
				threshold = 1.0
			if (target_position - global_position).length() > threshold:
				handle_pathfind()
				accel_dir = accel_dir.normalized()
			else:
				if visibility_check():
					Global.player.damage()
				elif $Patience.is_stopped():
					accel_dir = Vector2.ZERO
					$Patience.start()
#				else:
#					rotation = 2.0*PI * $Patience.time_left / $Patience.wait_time
#					if visibility_check():
#						$Patience.stop()
				accel_dir = Vector2.ZERO
			velocity = accel_dir * max_speed
			velocity = move_and_slide(velocity)
			look_dir = velocity.normalized()
			if velocity.length() > 0.25:
				rotation = get_look_dir()
		States.RETURNTOPATROL:
			target_position = patrol_path.global_position
			handle_pathfind()
			accel_dir = accel_dir.normalized()
			velocity = accel_dir * max_speed
			velocity = move_and_slide(velocity)
			look_dir = accel_dir
			rotation = get_look_dir()
			if visibility_check():
				target_position = Global.player.global_position
				state = States.CHASE
			elif (global_position - patrol_path.global_position).length() < 1.0:
				state = States.PATROL

func handle_pathfind():
	if player_is_visible:
		simple_path = (navigation as Navigation2D).get_simple_path(global_position, navigation.get_closest_point(target_position))
	if simple_path.size() > 0:
		accel_dir = simple_path[1] - simple_path[0]
	else:
		accel_dir = Vector2.ZERO

func get_look_dir():
	return Vector2.ZERO.angle_to_point(look_dir.normalized())

func _on_Patience_timeout():
	state = States.RETURNTOPATROL

func visibility_check():
	return $RayCast2D.get_collider() == Global.player and ( ((Global.player.global_position - global_position).length() <= 128 and look_dir.dot((Global.player.global_position - global_position).normalized()) > 0.7) or (Global.player.global_position - global_position).length() <= 20)
