extends Entity


class_name Player


export var target: NodePath
#-#-# PLAYER SPECIFIC THINGS #-#-#
onready var cast := get_node("CollisionShapeUpper/CamGroup/RayCast")
var mouse_sensitivity = 0.001
onready var cam_group := get_node("CollisionShapeUpper/CamGroup")
onready var cam := get_node("CollisionShapeUpper/CamGroup/Camera")
export(PackedScene) var bullet_scene
export(PackedScene) var knife_slash
var transform_dict: Dictionary
export (String, FILE) var weapon_primary_file_path = null
export (String, FILE) var weapon_secondary_file_path = null
export (String, FILE) var weapon_data_file_path = null
var input_dict := {}
onready var upper_collision_shape = $CollisionShapeUpper
onready var lower_collision_shape = $CollisionShapeLower
var hud

var weapon_data

var inventory = []
var current_item = 0
var lock_view = false
var lock_move = false
var base_fov = 70.0

enum input{
	GROUND_DIR,
	FLY_DIR,
	JUMP,
	RUN,
	CROUCH,
	ITEM_PRIMARY,
	ITEM_SECONDARY,
	ITEM_USE,
	LOOK_BASIS_X,
	LOOK_BASIS_Y,
	ITEM_PREV,
	ITEM_NEXT,
}

var look_rot: Vector2
var current_prompt: String = ""
onready var target_cam_transform = cam_group.transform
var item_manager = preload("res://items/item_manager.tres")

func _ready():
	look_rot = Vector2(
		cam_group.rotation.x,
		rotation.y
	)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cast.add_exception(self)

#	var weapon_data_file = File.new()
#	weapon_data_file.open(weapon_data_file_path, File.READ)
#	weapon_data = JSON.parse(weapon_data_file.get_as_text()).result
#
#	weapon_loadout_id[0] = "bullet_rifle"
#	weapon_clip_ammo[0] = weapon_data[0][weapon_loadout_id[0]]["clip_size"]
#	weapon_reserve_ammo[0] = weapon_data[0][weapon_loadout_id[0]]["reserve_ammo"]
#
#	weapon_loadout_id[1] = "bullet_pistol"
#	weapon_clip_ammo[1] = weapon_data[1][weapon_loadout_id[1]]["clip_size"]
#	weapon_reserve_ammo[1] = weapon_data[1][weapon_loadout_id[1]]["reserve_ammo"]
#
#	weapon_loadout_id[2] = "knife"
#	current_weapon_slot = 0


func _input(event) -> void:
	if event is InputEventMouseMotion and not lock_view:
		look_rot += Vector2(
			event.relative.y * mouse_sensitivity * -1,
			event.relative.x * mouse_sensitivity * -1
		)
		look_rot.x = clamp(look_rot.x, -PI/2, PI/2)


func handle_look():
	cam_group.rotation.x = look_rot.x
	rotation.y = look_rot.y
#	cam_group.transform = target_cam_transform


var bob: float


func _physics_process(delta):
	handle_input()
	current_prompt = ""
	if cast.is_colliding():
		var collider = cast.get_collider()
		if collider is Interactable:
			current_prompt = collider.prompt
			if input_dict[input.ITEM_USE]:
				collider.interact(self)
#		if collider is DroppedItem:
#			prompt_pickup = true
#			if input_dict[input.ITEM_USE]:
#				inventory.append(collider.pickup())
#		elif collider is Door:
#			if input_dict[input.ITEM_USE]:
#				collider.interact()
#		else:
#			prompt_pickup = false
	handle_item()
	bob += delta * velocity.length()
	handle_look()
	if not lock_move:
		handle_movement(delta)
	transform_dict[get_tree().get_frame()] = global_transform
	Performance.get_monitor(Performance.TIME_FPS)
	cam_group.transform.origin.y = 0.2 + abs(sin(bob * 2.0) / 8.0)
#	$CollisionShapeUpper/CamGroup/Camera.rotation.z = sin(bob * 2.0) / 64.0
	$CollisionShapeUpper/CamGroup/Camera.rotation.z = velocity.dot(-global_transform.basis.x / 64.0) + sin(bob * 2.0) / 64.0
	if cast.is_colliding():
		var tmp = cast.get_collision_point()
		var tmp2 = tmp - $CollisionShapeUpper/CamGroup/SpotLight.global_transform.origin
		tmp2 = -tmp2.normalized()
		$CollisionShapeUpper/CamGroup/SpotLight.global_transform.basis.z = tmp2
		$CollisionShapeUpper/CamGroup/SpotLight.global_transform.basis.x = tmp2.cross(Vector3.UP)
		$CollisionShapeUpper/CamGroup/SpotLight.global_transform.basis.y = $CollisionShapeUpper/CamGroup/SpotLight.global_transform.basis.x.cross(tmp2)

func handle_item():
	if inventory.size() > 0:
		var prev_item = inventory[current_item]
		if input_dict[input.ITEM_NEXT]:
			current_item += 1
			prev_item.remove()
		if input_dict[input.ITEM_PREV]:
			current_item -= 1
			prev_item.remove()
		current_item = wrapi(current_item, 0, inventory.size())
		inventory[current_item].active(cam_group)
		if input_dict[input.ITEM_PRIMARY]:
			inventory[current_item].primary()
		if input_dict[input.ITEM_SECONDARY]:
			inventory[current_item].secondary()

export(float) var max_speed_crouch := 7.5
export(float) var max_speed_walk := 12.5
export(float) var max_speed_run := 20.0
var walk_accel = 20.0
var base_stamina := 100.0
var stamina := base_stamina
var stamina_use_rate := 25.0
var stamina_recover_rate := 15.0
var gravity := 9.8
var snap: Vector3
export var stop_speed_walk = 20.0



func handle_accel(wish_dir: Vector3, accel: float, max_speed: float, friction: float, stop_speed: float, _delta: float) -> void:
	var final_vel = velocity * Vector3(1.0, 0.0, 1.0) + wish_dir * accel * _delta
	var friction_damp = pow(friction, _delta)
	final_vel *= friction_damp
	final_vel -= final_vel.normalized() * max(final_vel.length() - max_speed, 0.0)
	velocity.x = final_vel.x
	velocity.z = final_vel.z


func handle_input():
	var longitudinal_input = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	var vertical_input = Input.get_action_strength("move_jump") - Input.get_action_strength("move_crouch")
	var lateral_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	# dont forget to normalize again on server
	input_dict[input.GROUND_DIR] = (
			global_transform.basis.x * lateral_input +
			global_transform.basis.z * longitudinal_input
		).normalized()
	input_dict[input.FLY_DIR] = (
			cam_group.global_transform.basis.x * lateral_input +
			cam_group.global_transform.basis.y * vertical_input +
			cam_group.global_transform.basis.z * longitudinal_input
		).normalized()
	
	input_dict[input.JUMP] = Input.is_action_pressed("move_jump")
	input_dict[input.RUN] = Input.is_action_pressed("move_run")
	input_dict[input.CROUCH] = Input.is_action_pressed("move_crouch")
	input_dict[input.ITEM_PRIMARY] = Input.is_action_just_pressed("item_primary")
	input_dict[input.ITEM_SECONDARY] = Input.is_action_just_pressed("item_secondary")
	input_dict[input.ITEM_USE] = Input.is_action_just_pressed("item_use")
	# v find a way to only have 1 vector sent so hackers cant fuck with the server
	input_dict[input.LOOK_BASIS_Y] = transform.basis	
	input_dict[input.LOOK_BASIS_X] = cam_group.transform.basis
	input_dict[input.ITEM_PREV] = Input.is_action_just_released("item_prev")
	input_dict[input.ITEM_NEXT] = Input.is_action_just_released("item_next")
#var has_jumped: bool = false

func handle_movement(delta: float):
#	if input_dict[input.ITEM_PRIMARY]:
#		$CollisionShapeUpper/CamGroup/SpotLight.visible = not $CollisionShapeUpper/CamGroup/SpotLight.visible

	
	if input_dict.size() < input.size():
		return
	
	velocity.y -= gravity * delta
	velocity = move_and_slide_with_snap(
			velocity,
			-get_floor_normal(),
			snap,
			true,
			4,
			PI/4.0
			)
	
	snap = Vector3.UP	
	var on_floor = is_on_floor()
	var max_speed = max_speed_walk
	var friction = 0.1
	
	# crouching
	lower_collision_shape.transform.origin.y = 0.5
	if input_dict[input.CROUCH]:
		max_speed = max_speed_crouch
		upper_collision_shape.transform.origin.y = lerp(upper_collision_shape.transform.origin.y, 0.5, delta * 4.0)
		stamina += stamina_recover_rate * delta * 1.5
	else:
		upper_collision_shape.transform.origin.y = lerp(upper_collision_shape.transform.origin.y, 1.5, delta * 4.0)
		# running
		if input_dict[input.RUN] and stamina > 0.0:
			max_speed = max_speed_run
			stamina -= stamina_use_rate * delta
		else:
			stamina += stamina_recover_rate * delta
	stamina = clamp(stamina, 0.0, base_stamina)
	
	handle_accel(
			input_dict[input.GROUND_DIR],
			walk_accel,
			max_speed,
			friction,
			stop_speed_walk,
			delta
		)


#func get_item(item_id: String):
#	inventory.append(item_manager.get_item_resource(item_id))
