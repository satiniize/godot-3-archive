class_name BasePlayer

extends LivingBody

var role = Network.Role.GAMEMASTER

var inventory := {
	0: null,
	1: null,
	2: null,
	3: null,
	4: null,
	5: null,
	6: null,
	7: null,
	8: null,
	9: null,
}
var current_item_id = 0
var inventory_limit : int = 10

remotesync var input_dict = {}
puppet var weapon_rot = 0.0

#var hud
enum input{
	ACCEL_DIR
}
#var item_data = preload("res://player/weapons/item_data.tres")
#var breadcrumbs : PoolVector2Array
#var health = 50

#movement
var velocity := Vector2.ZERO
var accel := 256.0
var damp := 0.1
var max_speed := 72.0
var aim_dir : Vector2

master func input():
	input_dict[input.ACCEL_DIR] = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()


func movement(delta: float):
	if input_dict.size() == input.size():
		var new_vel := velocity
		new_vel += input_dict[input.ACCEL_DIR] * accel * delta
		if new_vel.dot(new_vel) < max_speed*max_speed:
			velocity = new_vel
		velocity *= pow(damp, delta)
		velocity = move_and_slide(velocity)


func give_item(item):
	for slot in inventory:
		if inventory[slot] == null:
			inventory[slot] = item
			return true
	return false


func _physics_process(delta):
	rpc("input")
	rset("input_dict", input_dict)
	if is_network_master():
		rset_unreliable("weapon_rot", weapon_rot)
		if get_tree().get_frame() % 120 == 0:
			rpc("sync_data", global_position)
	movement(delta)
	var cam_zoom = Vector2(1.0, 1.0)
	if Input.is_action_pressed("cam_zoom"):
		cam_zoom = Vector2(8.0, 8.0)
	$Camera2D.position = lerp($Camera2D.position, velocity / 2.0, 0.25)
	$Camera2D.zoom = lerp($Camera2D.zoom, cam_zoom, 0.25)
	$AnimatedSprite.scale = lerp($Camera2D.zoom, cam_zoom, 0.25)
	$AnimatedSprite.scale.x *= sign((get_global_mouse_position() - global_position).x)
	if is_network_master():
		$ItemPivot.look_at(get_global_mouse_position())
		weapon_rot = $ItemPivot.rotation
		$ItemPivot.scale.y = sign((get_global_mouse_position() - global_position).x)
	else:
		$ItemPivot.rotation = lerp($ItemPivot.rotation, weapon_rot, 0.5)
	handle_item()
	aim_dir = get_global_mouse_position() - global_position
	aim_dir = aim_dir.normalized()


func handle_item():
	if Input.is_action_just_released("next_slot"):
		current_item_id += 1
	if Input.is_action_just_released("prev_slot"):
		current_item_id -= 1
	var wrap = false
	if wrap:
		current_item_id = wrapi(current_item_id, 0, 10)
	else:
		current_item_id = int(clamp(current_item_id, 0, 9))
	var current_item = inventory[current_item_id]
	if current_item:
		$ItemPivot/Sprite.texture = current_item.texture
		if Input.is_action_pressed("item_primary"):
			current_item.primary(self)
		if Input.is_action_pressed("item_secondary"):
			current_item.secondary(self)
	else:
		$ItemPivot/Sprite.texture = null


func drop_item(slot : int):
	if inventory[slot]:
		var dropped_item = preload("res://gameworld/item_pickup.tscn")
		var dropped_item_instance = dropped_item.instance()
		dropped_item_instance.item = inventory[slot]
		get_tree().current_scene.add_child(dropped_item_instance)
		dropped_item_instance.global_position = global_position + Vector2(0.0, 24.0)
		inventory[slot] = null


puppet func sync_data(pos):
	global_position = pos
