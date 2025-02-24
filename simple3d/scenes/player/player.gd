extends KinematicBody

class_name Player

onready var cam_group: Spatial = get_node("cam_group")
onready var cast: RayCast = get_node("cam_group/cast")
onready var cam: Camera = get_node("cam_group/cam")
onready var hud: CanvasLayer = get_node("hud")
onready var ui_switcher = get_node("ui_switcher")
export var ui: PackedScene
var velocity: Vector3
var accel_dir: Vector3
var friction: float = 6.0
var ground_accel: float = 32.0
var air_accel: float = 2.0
var max_vel_ground: float = 20.0
var max_vel_air: float = 50.0
var gravity: float = 9.8

onready var cast_object = $cam_group/cast.get_collider()
var grab_object: RigidBody
var mouse_sensitivity: float = 0.1
var stored_meals: int = 0 setget set_stored_meals
var camera_clamp: Vector2
var currently_interacting: bool = false

var hand_state
enum {CLEAN, DIRTY}

var is_interacting: bool = false
var paused = false

func set_stored_meals(value: int):
	stored_meals = value
	stored_meals = clamp(stored_meals, 0, 5)

func _ready():
#	hud.toggle_visibility()
	Global.player = self

func _input(event) -> void:
	if event is InputEventMouseMotion and !is_interacting:
		rotate_y(deg2rad(event.relative.x * -1 * mouse_sensitivity))
		cam_group.rotate_x(deg2rad(event.relative.y * -1 * mouse_sensitivity))
		cam_group.rotation.x = clamp(cam_group.rotation.x, -PI/2, PI/2)
		$MeshInstance2.rotate_y(deg2rad(event.relative.x * mouse_sensitivity))\

func accelerate(_accel_dir: Vector3, prev_vel: Vector3, accel: float, max_vel: float, delta: float) -> Vector3:
	var proj_vel: float = prev_vel.dot(_accel_dir)
	var accel_vel: float = accel * delta
	if proj_vel + accel_vel > max_vel:
		accel_vel = max_vel - proj_vel
	return prev_vel + _accel_dir * accel_vel

func move_ground(_accel_dir: Vector3, prev_vel: Vector3, delta: float) -> Vector3:
	var speed: float = prev_vel.length()
	if speed != 0.0:
		var drop = speed * friction * delta
		prev_vel *= max(speed - drop, 0) / speed
	return accelerate(_accel_dir, prev_vel, ground_accel, max_vel_ground, delta)

func move_air(_accel_dir: Vector3, prev_vel: Vector3, delta: float) -> Vector3:
	return accelerate(_accel_dir, prev_vel, air_accel, max_vel_air, delta)

func movement(delta: float) -> void:
	var on_floor = is_on_floor()
	if !currently_interacting:
		accel_dir = (get_global_transform()[2] * (Global.down - Global.up) +
			get_global_transform()[2].rotated(Vector3.UP, PI/2.0) * (Global.right - Global.left)).normalized()
	else:
		accel_dir = Vector3.ZERO
	if on_floor:
		velocity = move_ground(accel_dir, velocity, delta)
	else:
		velocity = move_air(accel_dir, velocity, delta)
	velocity.y -= gravity * delta

func _physics_process(delta) -> void:
	if Global.game_start:
		cast_object = cast.get_collider()
		Global.player_object_interact = cast_object
		velocity = move_and_slide(velocity, Vector3.UP)
		movement(delta)
		interaction(delta)
		if Input.is_action_just_pressed("ui_cancel"):
			print(paused)
			get_tree().paused = true
			ui_switcher.switch_menu(ui_switcher.screens.PAUSE_MENU)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
func interaction(_delta):##hand is empty but still interacts with chair
	if Global.game_start:
		if Input.is_action_pressed("ui_left_click") and cast_object is Interactable:
			hud.check_arrows(cast_object.interact_type)
			if cast_object.needs_interaction:
				hud.progress_bar.show()
				hud.progress_bar.value = cast_object.percentage
				is_interacting = true
				Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
			else:
				interaction_fail()
		else:
			interaction_fail()

func interaction_fail():
	hud.progress_bar.hide()
	is_interacting = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hud.check_arrows(Interactable.interact_modes.NONE)
#
#func summon_ui():
#	hud = ui.instance()
#	add_child(hud)
