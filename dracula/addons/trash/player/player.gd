extends KinematicBody

export var target: NodePath
#-#-# PLAYER SPECIFIC THINGS #-#-#
onready var cast := get_node("CollisionShapeUpper/CamGroup/RayCast")
var mouse_sensitivity = 0.001
onready var cam_group := get_node("CollisionShapeUpper/CamGroup")
export(PackedScene) var bullet_scene
export(PackedScene) var knife_slash
var transform_dict: Dictionary
export (String, FILE) var weapon_primary_file_path = null
export (String, FILE) var weapon_secondary_file_path = null
export (String, FILE) var weapon_data_file_path = null
export (String, FILE) var game_items_path = null
var input_dict := {}

onready var upper_collision_shape = $CollisionShapeUpper
onready var lower_collision_shape = $CollisionShapeLower
var hud

var game_items_data

enum input{
	GROUND_DIR,
	FLY_DIR,
	JUMP,
	RUN,
	CROUCH,
	ATTACK_PRIMARY,
	ATTACK_SECONDARY,
	EQUIPMENT_RELOAD,
	LOOK_BASIS_X,
	LOOK_BASIS_Y,
}


func update_weapons():
	var weapon_slots = [
		"primary",
		"secondary",
		"melee"
	]
	for slot in range(3):
		var weapon_data = game_items_data["weapons"][weapon_loadout_id[slot]]
		weapon_loadout[slot] = weapon_data


func _ready():
	look_rot = Vector2(
		cam_group.rotation.x,
		rotation.y
	)
	
	var game_items_file = File.new()
	game_items_file.open(game_items_path, File.READ)
	var game_items_unparsed = game_items_file.get_as_text()
	game_items_data = JSON.parse(game_items_unparsed).result

	cast.add_exception(self)
	var starter_weapons = ["lcr", "glock18", "golok"]
#	var starter_weapons = {
#		"primary" : "lcr",
#		"secondary" : "glock18",
#		"melee" : "golok"
#	}
#	weapons_bought.append_array(starter_weapons)
	for slot in range(3):
		buy_weapons(starter_weapons[slot])
#		weapons_bought[slot].append(starter_weapons[slot])
		weapon_loadout_id[slot] = weapons_bought[slot][0]
#	weapon_loadout_id[0] = "lcr"
#	weapon_loadout_id[1] = "glock18"
#	weapon_loadout_id[2] = "golok"
	update_weapons()
	
	if is_network_master():
		hud = load("res://player/hud/hud.tscn").instance()
		get_node("/root").add_child(hud)
	
	hud.connect("buy_item", self, "buy_weapons")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
#	print(weapons_bought)
	current_weapon_slot = 0

func _unhandled_input(event) -> void:
	if is_network_master():
		if event is InputEventMouseMotion:
			look_rot += Vector2(
				event.relative.y * mouse_sensitivity * -1,
				event.relative.x * mouse_sensitivity * -1
			)
			look_rot.x = clamp(look_rot.x, 0, PI)


func handle_look():
	cam_group.rotation.x = look_rot.x + recoil_offset.y
	rotation.y = look_rot.y + recoil_offset.x


func update_hud():
	hud.get_node("Ping2").text = str(stepify(velocity.length(), 0.1))


func _physics_process(delta):
	print(weapon_loadout_id)
	hud.equipped_items = weapon_loadout_id
	hud.bought_items = weapons_bought
#	print(weapons_bought)
	handle_look()
	handle_movement(delta)
	handle_weapon(delta)
	transform_dict[get_tree().get_frame()] = global_transform
	hud.get_node("Ping2").text = str(stepify(velocity.length(), 0.1))
	Performance.get_monitor(Performance.TIME_FPS)
	hud.energy = energy / energy_capacity * 100.0
	if Input.is_action_pressed("debug_1"):
		token_balance += 5
	hud.get_node("PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer2/Token").text = str(token_balance)
	
	
export(float) var mass = 1000.0
export(float) var walk_force = 45000.0
export(float) var thrust_force = 30000
export(float) var jump_height = 2.0
var velocity := Vector3.ZERO
export(float) var max_speed_crouch := 7.5
export(float) var max_speed_walk := 12.5
export(float) var max_speed_run := 20.0
export(float) var max_speed_air := 5.0
export(float) var wall_climb_speed := 4.0
var energy_capacity := 5.0
var energy := energy_capacity
var energy_depletion_rate := 0.5
var energy_regeneration_rate := 0.3
var gravity := 9.8
var can_shoot: bool = true
var on_wall: bool = false
var normal: Vector3 = Vector3.ZERO
var snap: Vector3
export var max_speed_wall_run = 25.0
export var max_speed_fly = 25.0
export var stop_speed_walk = 20.0
export var stop_speed_slide = 0.0

var has_double_jumped: bool = false
var double_jump_height: float = 2.0


func handle_accel(wish_dir: Vector3, accel: float, max_speed: float, _delta: float) -> void:
	var final_vel = velocity + wish_dir * accel * _delta
	if (final_vel.dot(wish_dir) < max_speed):
		velocity = final_vel

func test_pow(delta):
	var friction_force = pow(0.8, delta)

func handle_friction(friction: float, stop_speed: float, delta: float) -> void:
	var friction_force = pow(friction, delta)
	if (velocity * (1.0 - friction_force)).length() > stop_speed * delta:
		velocity *= friction_force
	else:
		velocity -= min(stop_speed * delta, velocity.length()) * velocity.normalized()

func handle_jump(jump_vec: Vector3):
	velocity += jump_vec
	snap = Vector3.ZERO

#func handle_accel(
#		_force : float,
#		_friction : float,
#		_min_friction : float,
#		_max_speed : float,
#		_limit_strict : bool,
#		_dir : Vector3,
#		_delta : float
#	):
#
#	var _accel : Vector3 = _force / mass * _dir
#	var _new_velocity : Vector3 = velocity + _accel * _delta
#	var _damp_friction : float = (
#							1.0 /
#							(_delta / (1.0 - _friction) + 1.0)
#						)
#
#
##		_accel *= _new_velocity.length() / _max_speed
#	if velocity.dot(_dir) < _max_speed:
#		velocity += _accel * _delta
#
#	if velocity.length() * (1.0 - _damp_friction) < _min_friction * _delta:
#		velocity -= velocity.normalized() * _min_friction * _delta
#	velocity *= _damp_friction
	
#		_accel *= _max_speed / _new_velocity.dot(_dir)
#	if ((_limit_strict and (_new_velocity * Vector3(1.0, 0.0, 1.0)).length() > _max_speed) or 
#		_new_velocity.dot(_dir) > _max_speed):
#			_new_velocity *= velocity.length() / _new_velocity.length()
	#fix, y vector is still calculated
#	velocity.x = _new_velocity.x
#	velocity.z = _new_velocity.z

func update_wall_collision():
	var is_on_wall_temp = false
	var normal_temp = Vector3.ZERO
	for i in $CollisionShapeLower/Walldetect.get_children():
		is_on_wall_temp = is_on_wall_temp or i.is_colliding()
		if i.is_colliding():
			normal_temp = i.get_collision_normal()
	on_wall = is_on_wall_temp
	if on_wall:
		normal = normal_temp
	else:
		normal = Vector3.ZERO

func handle_wall_climb(wish_dir: Vector3, on_wall: bool, delta: float):
	if on_wall:
		var friction_force = pow(0.01, delta)
		velocity *= Vector3(friction_force, 1.0, friction_force)
		if wish_dir.dot(-normal) >= sqrt(2.0) / 2.0:
			velocity.y = wall_climb_speed


func handle_wall_run(on_wall: bool, wish_dir: Vector3, delta: float):
	if on_wall:
		var friction_force = pow(0.001, delta)
		velocity *= Vector3(1.0, friction_force, 1.0)


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
	input_dict[input.ATTACK_PRIMARY] = Input.is_action_pressed("attack_primary")
	input_dict[input.ATTACK_SECONDARY] = Input.is_action_pressed("attack_secondary")
	input_dict[input.EQUIPMENT_RELOAD] = Input.is_action_pressed("weapon_reload")
	# v find a way to only have 1 vector sent so hackers cant fuck with the server
	input_dict[input.LOOK_BASIS_Y] = transform.basis	
	input_dict[input.LOOK_BASIS_X] = cam_group.transform.basis
	#input_dict[input.LOOK_DIR_Z] = cam_group.global_transform.basis.z		use vector math to figure out the rest
var has_jumped: bool = false

func handle_movement(delta: float):
	# weird bug
	# when pressing directional buttons after quake bunny hop holding
	# auto bunny hop is disabled and acceleration is prioritized
	# in air space + directional
	if is_network_master():
		handle_input()
		if not get_tree().is_network_server():
			rpc_unreliable_id(1, "send_inputs", input_dict)
	else: # isnt controlled, sync data
		if input_dict.size() > 0:
			transform.basis = input_dict[input.LOOK_BASIS_Y]
			cam_group.transform.basis = input_dict[input.LOOK_BASIS_X]
	if input_dict.size() < input.size():
		return
	
	velocity.y -= gravity * delta
	velocity = move_and_slide_with_snap(
			velocity,
			-get_floor_normal(),
			snap,
			not input_dict[input.CROUCH],
			4,
			PI/4.0
			)
	
	snap = Vector3.UP	
	var on_floor = is_on_floor()
	energy += 0.2 * delta
	if on_floor: # player is on the ground
		ground_movement(delta)
#		# declare variables for later
#		var energy_delta
#		var force = walk_force
#		var max_speed = max_speed_walk
#		var friction = 0.1
#
#		has_double_jumped = false
#
#		# crouching
#		lower_collision_shape.transform.origin.y = 1
#		if input_dict[input.CROUCH]:
#			if upper_collision_shape.transform.origin.y == 2:
#				global_transform.origin.y += 1
#			max_speed = max_speed_crouch
#			upper_collision_shape.transform.origin.y = 1
#			# sliding
#			if velocity.length() > max_speed_crouch:
#				force = walk_force / 20.0
#				friction = 0.8
#		else:
#			upper_collision_shape.transform.origin.y = 2
#
#		# running
#		if input_dict[input.RUN]:
#			max_speed = max_speed_run
#			energy -= 1.0 * delta
#
#		# friciton
#		if input_dict[input.CROUCH] and velocity.length() > max_speed_crouch:
#			handle_friction(friction, stop_speed_slide, delta)
#		else:
#			handle_friction(friction, stop_speed_walk, delta)
#
#		# accelerate
##		handle_accel(
##			force,
##			friction,
##			stop_speed_walk,
##			max_speed,
##			false,
##			input_dict[input.GROUND_DIR],
##			delta
##		)
#
#		#jumping
#		if input_dict[input.JUMP]:
#			if not has_jumped:
#				snap = Vector3.ZERO
#				var jump_vec = sqrt(2.0 * gravity * jump_height)
#				handle_jump(jump_vec * Vector3.UP)
#				has_jumped = true
#		else:
#			has_jumped = false
#
#		handle_accel(
#			input_dict[input.GROUND_DIR],
#			force / mass,
#			max_speed,
#			delta
#		)
#
#
	else: # player is in the air
		air_movement(delta)
#		var force = thrust_force
#		var max_speed = max_speed_air
#		# crouching
#		# fix this shit
#		if input_dict[input.CROUCH]:
#			if upper_collision_shape.transform.origin.y == 1:
#				global_transform.origin.y -= 1
#			lower_collision_shape.transform.origin.y = 2
#		else:
#			lower_collision_shape.transform.origin.y = 1
#		upper_collision_shape.transform.origin.y = 2
#
#		# update wall collision and normal because is_on_wall() is shit for this
#		update_wall_collision()
#
#		# wall jumping and quake style bunny hopping
#		if input_dict[input.JUMP]:
#			if not has_jumped:
#				if not has_double_jumped:
#					var jump_vec = sqrt(2.0 * gravity * jump_height)
#					handle_jump(max(jump_vec - velocity.y, jump_vec) * Vector3.UP)
#					has_double_jumped = true
#					has_jumped = true
#		else:
#			has_jumped = false
#
##		print(has_jumped)
#		# wallclimbing and wallrunning | please improve using float modulate fmod()
#		if on_wall:
#			if global_transform.basis.z.dot(normal) >= sqrt(2.0) / 2.0:
#				handle_wall_climb(input_dict[input.GROUND_DIR], on_wall, delta)
#			elif global_transform.basis.z.dot(normal) > 0.0:
#				max_speed = max_speed_wall_run
#				velocity.y += gravity * delta
#				handle_wall_run(on_wall, input_dict[input.GROUND_DIR], delta)
#
#		# accelerate and air strafe
#		# should probably add a hard speed cap
#		handle_accel(
#				input_dict[input.GROUND_DIR],
#				force / mass,
#				max_speed,
#				delta
#			)


	if get_tree().is_network_server():
		rpc_unreliable("sync_data", global_transform.origin, velocity, input_dict)

func ground_movement(delta):
		# declare variables for later
		var energy_delta
		var force = walk_force
		var max_speed = max_speed_walk
		var friction = 0.1
		
		has_double_jumped = false
		
		# crouching
		lower_collision_shape.transform.origin.y = 1
		if input_dict[input.CROUCH]:
			if upper_collision_shape.transform.origin.y == 2:
				global_transform.origin.y += 1
			max_speed = max_speed_crouch
			upper_collision_shape.transform.origin.y = 1
			# sliding
			if velocity.length() > max_speed_crouch:
				force = walk_force / 20.0
				friction = 0.8
		else:
			upper_collision_shape.transform.origin.y = 2
			
		# running
		if input_dict[input.RUN]:
			max_speed = max_speed_run
			energy -= 1.0 * delta
		
		# friciton
		if input_dict[input.CROUCH] and velocity.length() > max_speed_crouch:
			handle_friction(friction, stop_speed_slide, delta)
		else:
			handle_friction(friction, stop_speed_walk, delta)
		
		#jumping
		if input_dict[input.JUMP]:
			if not has_jumped:
				snap = Vector3.ZERO
				var jump_vec = sqrt(2.0 * gravity * jump_height)
				handle_jump(jump_vec * Vector3.UP)
				has_jumped = true
		else:
			has_jumped = false
			
		handle_accel(
			input_dict[input.GROUND_DIR],
			force / mass,
			max_speed,
			delta
		)
		
		
	
func air_movement(delta):

		var force = thrust_force
		var max_speed = max_speed_air
		# crouching
		# fix this shit
		if input_dict[input.CROUCH]:
			if upper_collision_shape.transform.origin.y == 1:
				global_transform.origin.y -= 1
			lower_collision_shape.transform.origin.y = 2
		else:
			lower_collision_shape.transform.origin.y = 1
		upper_collision_shape.transform.origin.y = 2
		
		# update wall collision and normal because is_on_wall() is shit for this
		update_wall_collision()

		# wall jumping and quake style bunny hopping
		if input_dict[input.JUMP]:
			if not has_jumped:
				if not has_double_jumped:
					var jump_vec = sqrt(2.0 * gravity * jump_height)
					handle_jump(max(jump_vec - velocity.y, jump_vec) * Vector3.UP)
					has_double_jumped = true
					has_jumped = true
		else:
			has_jumped = false
		
#		print(has_jumped)
		# wallclimbing and wallrunning | please improve using float modulate fmod()
		if on_wall:
			if global_transform.basis.z.dot(normal) >= sqrt(2.0) / 2.0:
				handle_wall_climb(input_dict[input.GROUND_DIR], on_wall, delta)
			elif global_transform.basis.z.dot(normal) > 0.0:
				max_speed = max_speed_wall_run
				velocity.y += gravity * delta
				handle_wall_run(on_wall, input_dict[input.GROUND_DIR], delta)

		# accelerate and air strafe
		# should probably add a hard speed cap
		handle_accel(
				input_dict[input.GROUND_DIR],
				force / mass,
				max_speed,
				delta
			)

remote func send_inputs(dict): #for dedicated servers should probably only send to server and not other clients
#	if (not input_dict[input.RUN] or dict[input.RUN]) and dict[input.RUN]:
#		# should only be true when the input changes and pressed
#		# not sure where to put it though
#		# do something like
#		# is_jumping = !is_jumping # invert value for toggle style input like flying and running
#		pass
	input_dict = dict


remote func sync_data(new_origin, new_velocity, dict):
	if not get_tree().is_network_server() and get_tree().get_rpc_sender_id() == 1:
		global_transform.origin = new_origin
		velocity = new_velocity
		if not is_network_master():
			input_dict = dict
			transform.basis = dict[input.LOOK_BASIS_Y]
			cam_group.transform.basis = dict[input.LOOK_BASIS_X]
		
var look_dir_blend: float

func _process(delta):
	look_dir_blend = cam_group.global_transform.basis.z.dot(Vector3.DOWN)
	$untitled.get_node("AnimationTree").set("parameters/look_dir/blend_position", look_dir_blend)
	var condition = is_network_master()
	$CollisionShapeUpper/CamGroup/Camera.current = condition
	$untitled.visible = not condition
	$world_gun.visible = not condition
	if hud != null:
		hud.get_node("ViewportContainer/Viewport/Spatial").global_transform = cam_group.global_transform


var recoil_offset: Vector2 #maybe calculate in radians

var look_rot: Vector2
var wave_phase = 0.0

var current_weapon_slot

#var weapon_loadout_type = {
#	"primary" : null,
#	"secondary" : null,
#	"melee" : null
#}
var weapon_loadout_id = [
	null,
	null,
	null
]
#var weapon_loadout_path = {
#	"primary" : null,
#	"secondary" : null,
#	"melee" : null
#}
var weapon_loadout = {}
#simple check if target equip is in this list, if not, then dont equip and dont call update_weapons()
var weapons_bought = [
	[],
	[],
	[]
]

# list all purchased weapons? or lose on death
#var weapon_loadout_attachments

#var weapon_clip_ammo = {}
#var weapon_reserve_ammo = {}
# ^^^ replace with broader data so multiple types can use
# vvv like this, store cooldown, infinite mags? all sorts
#var weapon_temp_data = {}

var weapon_delay_timer
var weapon_cooldown_timer := 0.0

enum AttachmentSlots {
	BARREL,
	SIGHTS,
	STOCK,
	GRIP,
	MAGAZINE,
}

func handle_weapon(delta: float):
#	var slots = [
#		"primary",
#		"secondary",
#		"melee"
#	]
	var weapon_slot_offset = 0
	if Input.is_action_just_released("weapon_next"):
		weapon_slot_offset += 1
	if Input.is_action_just_released("weapon_previous"):
		weapon_slot_offset -= 1
#	weapon_slot_offset = wrapi(slots.find(current_weapon_slot) + weapon_slot_offset, 0, 3)
	weapon_slot_offset = wrapi(current_weapon_slot + weapon_slot_offset, 0, 3)
	current_weapon_slot = weapon_slot_offset
#	current_weapon_slot = current_weapon_slot % 3

#	var current_weapon_data = weapon_data[current_weapon_slot][weapon_loadout_id[current_weapon_slot]]
	var current_weapon_data = weapon_loadout[current_weapon_slot]
	hud.weapon_name = current_weapon_data["name"]
	hud.weapon_image = load(current_weapon_data["image"])

	weapon_cooldown_timer -= delta
	weapon_cooldown_timer = max(weapon_cooldown_timer, 0.0)

#	match current_weapon_data["type"]:
#		"bullet":
#	if input_dict[input.EQUIPMENT_RELOAD]:
#		var reload_bullet_amount = min(
#				(
#					current_weapon_data["clip_size"] -
#					weapon_clip_ammo[current_weapon_slot]
#				),
#				weapon_reserve_ammo[current_weapon_slot]
#			)
#		weapon_reserve_ammo[current_weapon_slot] -= reload_bullet_amount
#		weapon_clip_ammo[current_weapon_slot] += reload_bullet_amount
#
#	recoil_offset *= pow(current_weapon_data["recoil_decay"], delta)
#	match weapon_loadout_path[current_weapon_slot][1]:
	match current_weapon_data["type"]:
		"bullet":
			if input_dict[input.EQUIPMENT_RELOAD]:
				var reload_bullet_amount = min(
						(
							current_weapon_data["clip_size"] -
							current_weapon_data["mutable_data"]["clip_ammo"]
						),
						current_weapon_data["mutable_data"]["reserve_ammo"]
					)
				current_weapon_data["mutable_data"]["reserve_ammo"] -= reload_bullet_amount
				current_weapon_data["mutable_data"]["clip_ammo"] += reload_bullet_amount

			recoil_offset *= pow(current_weapon_data["recoil_decay"], delta)

			hud.clip_ammo = current_weapon_data["mutable_data"]["clip_ammo"]
			hud.reserve_ammo = current_weapon_data["mutable_data"]["reserve_ammo"]

#			can_shoot = (
#					current_weapon_data["firing_mode"] == 1 and
#					weapon_clip_ammo[current_weapon_slot] > 0
#					)
			if input_dict[input.ATTACK_PRIMARY]:
				if weapon_cooldown_timer <= 0.0 and can_shoot:
					var shoot_dir: Vector3 = -cam_group.global_transform.basis.z

					shoot_dir = shoot_dir.rotated( #radial
							cam_group.global_transform.basis.x,
							rand_range(0.0, current_weapon_data["spread"] * PI / 2.0)
							)
					shoot_dir = shoot_dir.rotated( #tangent
							cam_group.global_transform.basis.z,
							rand_range(0.0, 2.0*PI)
							)

					var bullet_instance = bullet_scene.instance()
					get_tree().current_scene.add_child(bullet_instance)
					bullet_instance.setup(
							cam_group.global_transform.origin,
							shoot_dir,
							delta
						)

					weapon_cooldown_timer = 1.0 / (current_weapon_data["fire_rate"] / 60.0)

					wave_phase += current_weapon_data["phase_speed"] * PI * delta

					recoil_offset.y += current_weapon_data["offset_y_speed"]
					recoil_offset.x += current_weapon_data["offset_x_speed"] * pow(recoil_offset.y, 2.0) * sin(wave_phase)

#					weapon_clip_ammo[current_weapon_slot] -= 1
					current_weapon_data["mutable_data"]["clip_ammo"] -= 1

					can_shoot = (
							current_weapon_data["firing_mode"] == 1 and
							current_weapon_data["mutable_data"]["clip_ammo"] > 0
							)
			else:
				can_shoot = current_weapon_data["mutable_data"]["clip_ammo"] > 0
#				can_shoot = weapon_clip_ammo[current_weapon_slot] > 0

		"knife":
			hud.clip_ammo = "-"
			hud.reserve_ammo = "-"
			var _cast = $CollisionShapeUpper/CamGroup/RayCast
			if input_dict[input.ATTACK_PRIMARY] and weapon_cooldown_timer <= 0.0:
				if _cast.is_colliding():
					if (_cast.get_collision_point() - _cast.global_transform.origin).length() <= current_weapon_data["range"]:
						var _normal = _cast.get_collision_normal()
						var knife_slash_instance = knife_slash.instance()
						var look_dir = -cam_group.global_transform.basis.z
						var cross_product1 = look_dir.cross(_normal).normalized()
						var cross_product2 = cross_product1.cross(_normal).normalized()
						get_tree().current_scene.add_child(knife_slash_instance)
						knife_slash_instance.global_transform.origin = _cast.get_collision_point() + _normal * 0.004
						knife_slash_instance.global_transform.basis.z = _normal
						knife_slash_instance.global_transform.basis.x = cross_product2.normalized()
						knife_slash_instance.global_transform.basis.y = cross_product1.normalized()
				weapon_cooldown_timer = 1.0 / (current_weapon_data["fire_rate"] / 60.0)
		"repairgun":
			hud.clip_ammo = current_weapon_data["mutable_data"]["charge"]
			hud.reserve_ammo = current_weapon_data["max_charge"]
			if input_dict[input.ATTACK_PRIMARY]:
				current_weapon_data["mutable_data"]["charge"] -= round(current_weapon_data["depletion_rate"] * delta)
				if cast.get_collider().get("health") != null:
					cast.get_collider().damage(-ceil(current_weapon_data["repair_rate"] * delta))
func get_recoil_pos():
	pass
	
func handle_network():
		if get_tree().is_network_server():
			rpc_unreliable("sync_data", global_transform.origin, velocity, input_dict)
	
var max_health = 100
var max_stamina = 100
var max_shield = 100
var token_balance = 0


func buy_weapons(item_id : String):
	var weapon_data = game_items_data["weapons"][item_id]
	var price = weapon_data["price"]
	var slot = int(weapon_data["slot"])
	if item_id in weapons_bought[slot]:
		return
	token_balance -= price
	weapons_bought[slot].append(item_id)
	weapon_loadout_id[slot] = item_id
	call_deferred("update_weapons")


