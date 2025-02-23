class_name Player
extends LivingBody

var wish_look := Vector2.ZERO
var mouse_movement: Vector2 = Vector2.ZERO
var recoil_offset: Vector2 = Vector2.ZERO
var finalized_recoil: Vector2 = Vector2.ZERO
onready var current_weapon := get_node("CollisionShapeUpper/CamGroup/exampleGun")
onready var cast := get_node("CollisionShapeUpper/CamGroup/RayCast")
var mouse_sensitivity = 0.1
onready var cam_group := get_node("CollisionShapeUpper/CamGroup")
export(PackedScene) var bullet_decal

func damage(amount: float):
	health -= amount
	health = clamp(health, 1.0, 100.0)

func _ready():
	Global.player = self
#	print(Global.player)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cast.add_exception(self)

func _input(event) -> void:
	if event is InputEventMouseMotion:
		mouse_movement += event.relative

func handle_look(_wish_look: Vector2, recoil: Vector2, delta: float):
	var bias = current_weapon.get_node("RecoilTimer").time_left / current_weapon.get_node("RecoilTimer").wait_time
	finalized_recoil = recoil * bias
	wish_look += _wish_look * -mouse_sensitivity * delta
	wish_look.y = clamp(wish_look.y, -PI/2, PI/2)
	rotation.y = wish_look.x + finalized_recoil.x
	cam_group.rotation.x = wish_look.y + finalized_recoil.y
	mouse_movement = Vector2.ZERO

func handle_shoot(delta: float):
	var primary_shoot = Input.is_action_pressed("primary_shoot")
	var cast_is_colliding = (cast as RayCast).is_colliding()
	if current_weapon.handle_fire(primary_shoot, delta):
		$CollisionShapeUpper/CamGroup/AK47.translation.z = -0.1
		$CollisionShapeUpper/CamGroup/AK47.rotation_degrees.x = 5
		if cast_is_colliding:
			if cast.get_collider() is LivingBody:
				(cast.get_collider() as LivingBody).damage(20.0)
			else:
				current_weapon.summon_bullet_decal(bullet_decal, cast.get_collider(), cast.get_collision_point(), cast.get_collision_normal())
		recoil_offset = current_weapon.get_recoil(finalized_recoil, delta)
	if current_weapon.get_node("RecoilTimer").is_stopped():
		recoil_offset = Vector2.ZERO

func handle_crouch(delta: float):
	if !Input.is_action_pressed("crouch") and !$CanStand.is_colliding():
		$CollisionShapeUpper.translation.y = float_interpolate($CollisionShapeUpper.translation.y, 1.25, delta * 8.0)
	else:
		$CollisionShapeUpper.translation.y = float_interpolate($CollisionShapeUpper.translation.y, 0.45, delta * 8.0)

func handle_recoil_anim(delta: float):
	$CollisionShapeUpper/CamGroup/AK47.translation.z = float_interpolate($CollisionShapeUpper/CamGroup/AK47.translation.z, -0.2, delta * 16.0)
	$CollisionShapeUpper/CamGroup/AK47.rotation_degrees.x = float_interpolate($CollisionShapeUpper/CamGroup/AK47.rotation_degrees.x, 0, delta * 16.0)

func handle_minimap():
	var size = 320.0
	var player_pos = global_transform.origin + Vector3(80.0, 0, 80.0)
	var player_pos_lateral = Vector2(player_pos.x, player_pos.z)
#	var player_vel_lateral = Vector2(velocity.x, velocity.z)
#	var rot = Vector2.ZERO.angle_to_point()
	var rot = rotation.y
	player_pos_lateral = player_pos_lateral / 160 * 320.0
	$CanvasLayer/playersprite.rect_position = player_pos_lateral
	$CanvasLayer/playersprite.rect_rotation = -(rot * 90.0 / PI * 2.0) + 180.0

func _physics_process(delta):
	$CanvasLayer/ProgressBar.value = health
	var forward_input = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	var side_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var jump_input = Input.is_action_pressed("ui_accept")
	var run_input = Input.is_action_pressed("run")
	var forward = get_global_transform()[2].rotated(Vector3.UP, PI) * forward_input
	var side = get_global_transform()[2].rotated(Vector3.UP, PI/2.0) * side_input
	accel_dir = (forward * forward_move + side * side_move).normalized()
	handle_move(accel_dir, jump_input, run_input, Input.is_action_pressed("crouch"), delta)
	handle_shoot(delta)
	handle_look(mouse_movement, recoil_offset, delta)
	handle_crouch(delta)
	$CanvasLayer/Label.text = str(Performance.get_monitor(Performance.TIME_FPS))
	handle_recoil_anim(delta)
	handle_minimap()
