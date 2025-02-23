extends BasePlayer

class_name Warrior

var health = 50

func _physics_process(delta):
	hud.health = health
	$Camera2D.current = is_network_master()
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
	$Camera2D.position = velocity / 2.0
	$Camera2D.zoom = lerp($Camera2D.zoom, cam_zoom, 0.25)
	$AnimatedSprite.scale = lerp($Camera2D.zoom, cam_zoom, 0.25)
	$AnimatedSprite.scale.x *= ((get_global_mouse_position() - global_position) * Vector2(1.0, 0.0)).normalized().dot(Vector2(1.0, 0.0))
	$Particles2D.emitting = velocity.length() > 32.0
	if is_network_master():
		$ItemManager/ItemPivot.look_at(get_global_mouse_position())
		weapon_rot = $ItemManager/ItemPivot.rotation
	else:
		$ItemManager/ItemPivot.rotation = lerp($ItemManager/ItemPivot.rotation, weapon_rot, 0.5)
	if inventory.size() == 0:
		$ItemManager/ItemPivot/Sprite.texture = null
	else:
		$ItemManager/ItemPivot/Sprite.texture = item_data.items[inventory[current_item_id]]["image"]
	$ItemManager/ItemPivot.scale.y = ((get_global_mouse_position() - global_position) * Vector2(1.0, 0.0)).normalized().dot(Vector2(1.0, 0.0))
	update()
	$ItemManager.current_item_id = inventory[current_item_id]


func _on_Timer_timeout():
	var size = 32
	breadcrumbs.append(global_position)
#	if breadcrumbs.size() > 1024:
#		breadcrumbs.remove(0)
