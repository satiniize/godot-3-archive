extends Node
#var detection: float
#var detection_rate: float = 128.0
#export var alerted: Texture
#export var curious: Texture
#export var alerted_mask: Texture
#export var curious_mask: Texture
#	for i in $sight.get_overlapping_bodies():
#		match i.get_class():
#			KinematicBody2D:
#				if i == self:
#					pass
##					cast.rotation = self.get_angle_to(i.global_position)
#			_:
#				pass
#	if cast_colliding in $sight.get_overlapping_bodies():
#		match cast_colliding.get("type"):##NEEDS IMPROVEMENT
#			"player":
#				detection += detection_rate * delta
#			"crate":
#				if cast_colliding.grabbed:
#					detection += detection_rate * delta
#				else:
#					detection -= detection_rate * delta
#			_:
#				detection -= detection_rate * delta
#	else:
#		detection -= detection_rate * delta
#	match state:
#		IDLE:
#			handle_alert()
#			path_find(last_seen)
#		SEARCH:
#			path_find(last_seen)
#			if cast.get_collider() == player:
#				detection += detection_rate * delta
#				last_seen = player.global_position
#			if detection < 100.0:
#				state = IDLE
#		PATROL:
#			pass
#func handle_alert() -> void:#Detection
#	if detection < 100.0 and detection > 0:
#		alert.texture = curious
#		alert_mask.texture = curious_mask
#		alert.show()
#	elif int(detection) > 100:
#		last_seen = player.global_position
#		alert.texture = alerted
#		alert_mask.texture = alerted_mask
#		alert.show()
#		state = SEARCH
#	else:
#		alert.hide()
#	detection = max(detection, 0.0)
#	detection = min(detection, 150.0)
#	$sight.rotation = self.get_angle_to(velocity.normalized() + global_position)
#	var compass1 = target1.get(spot)
#	var compass2
#	print(target1.source)
#	match spot:
#		"north":
#			compass2 = target2.get("south")
#		"south":
#			compass2 = target2.get("north")
#		"west":
#			compass2 = target2.get("east")
#		"east":
#			compass2 = target2.get("west")
#	target2.global_position = compass1.global_position - compass2.position
	###WORKS FOR SOUTH ENTRANCE
#	$variant2.global_position = $variant1.south.global_position - Vector2($variant2.south.global_position.x, 0)
#	$variant2.global_position = $variant1.west.global_position - $variant2.east.position ### WORKS
#	$variant2.global_position = $variant1.south.global_position - $variant2.north.position
#func get_compass(value: int):
#	match value:
#		NORTH:
#			return north
#		SOUTH:
#			return south
#		WEST:
#			return west
#		EAST:
#			return east
#var rotation_normal: Dictionary = {0: Vector2(1.0, 0.0), 1: Vector2(0.0, 1.0), 2: Vector2(-1.0, 0.0), 3: Vector2(0.0, -1.0)}
#	target2.global_position = (compass1.global_position) - (global_position - compass1.global_position)
#	target2.global_position = (target1.global_position + (compass1.position * rotation_normal[new_rotation])) - (compass2.position * rotation_normal[custom_rotation])
#	target2.global_position = (compass1.global_position) - (compass2.position)
#	custom_rotation = randi() % 4
#	var compass2 = target2.source[(spot) % 4]
#	var compass1 = target1.target[(spot) % 4]
#	target2.global_position = (compass1.global_position) - (compass2.position)
#	var compass2 = target2.source[(3 - spot - custom_rotation) % 4]
#
#func _on_overlap(_area):
#	custom_rotation = randi() % 4
#
#	print("bruh")
##	allign(prev_room, self, prev_spot, prev_rotation)
#	get_parent().get_parent().overlapped = true
#func _ready():
#	prev_spot = custom_rotation
#		prev_room = instance
#		prev_room_rotation = instance.custom_rotation
#		instance.prev_rotation = prev_rotation
#		instance.prev_spot = spot
		
		
#	var prev_rotation
#	var prev_room
#	for i in range(0, length):
#		var instance
#		instance = self.get("variant" + str(randi() % 5 + 1)).instance()
#		rooms.add_child(instance)
#		var spot = randi() % 4
#		if i == 0:
#			instance.global_position = Vector2.ZERO
#		else:
#			instance.entrance = prev_room
#			instance.allign(prev_room, instance, spot, prev_rotation)
#			print(spot, prev_rotation, instance.custom_rotation)
#			instance.prev_room = prev_room
#
#		prev_room = instance
#		prev_rotation = instance.custom_rotation
#		instance.prev_rotation = prev_rotation
#		instance.prev_spot = spot
#	if world_clip.get_overlapping_areas().size() > 0:
#		prev_pos = global_position
#	else:
#		velocity = (prev_pos - global_position) * 128
#func _on_MobTimer_timeout():
#	$MobPath/MobSpawnLocation.offset = randi()
#	var mob = Mob.instance()
#	add_child(mob)
#	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
#	mob.position = $MobPath/MobSpawnLocation.position
#	direction += rand_range(-PI / 4, PI / 4)
#	mob.rotation = direction
#	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0).rotated(direction)
#	# warning-ignore:return_value_discarded
#	$HUD.connect("start_game", mob, "_on_start_game")
#	alert = get_node("alert")
#	alert_mask = get_node("alert/alert_mask")
#		reset_cooldown(5)
#		clear_level()
#		reset_cooldown(0)
#		jumlah_level = randi() % 5 + 5
#		generate(jumlah_level)

#func clear_level() -> void:
#	for child in rooms.get_children():
#		child.queue_free()
#	var new_state
#	match randi() % 4:
#		0:
#			new_state = states.RETREAT
#		1:
#			new_state = states.STAND
#		2:
#			new_state = states.TOWARDS
#		3:
#			new_state = states.STRAFE
#	state = new_state
#		if points.size() > 1:
#			var distance = points[1] - self.global_position
#			var direction = distance.normalized()
#			velocity += speed * direction
#		else:
#			velocity *= 0.8
#	$player.enemy_spawn.offset = randi()
#	var enemy = enemy1.instance()
#	enemy.player = $player
#	enemy.nav = get_node(nav_path)
#	get_node("enemies").add_child(enemy)
#	enemy.global_position = $player.enemy_spawn.global_position

#func _on_Variant1_renew(number: int) -> void:
#	var random_room = randi() % 4
#	var new_room
#	var pos
#
#	match random_room:
#		0:
#			new_room = var1.instance()
#		1:
#			new_room = var2.instance()
#		2:
#			new_room = var3.instance()
#		3:
#			new_room = var4.instance()
#
#	get_node("Rooms").call_deferred("add_child", new_room)
#	new_room.connect("renew", self, "_on_Variant1_renew")
#	match number:
#func _process(_delta):
#	if overlapped or Input.is_action_just_pressed("debug"):
#		get_tree().reload_current_scene()

#func _process(delta):
#	if init:
#		print(room_ke)
#		if room_ke == get_parent().get_parent().room_step:
#			if room_ke > 0:
#				prev_rotation = prev_room.custom_rotation
#				allign(prev_room, self, spot, prev_rotation)
#			if buffer_timer.time_left < 0.1:
#				$overlap.monitoring = false
#				$overlap.monitorable = true
#				get_parent().get_parent().room_step += 1
#		if get_parent().get_parent().finished_generating:
#			create_opening(prev_room)
			
			
#	if running:
#		track_change = times_evaluated
#		if init:
#			print("hmm3")
#			prev_rotation = prev_room.custom_rotation
#			allign(prev_room, self, spot, prev_rotation)
#		if get_parent().get_parent().finished_generating:
#			create_opening(prev_room)
##		finished_alligning = track_change != times_evaluated
#		if true:
#			print("hmm1")
#			get_parent().get_parent().reset_cooldown(1)
#			running = false
#		$overlap.monitoring = false
#	for i in rooms_array:
#		if i.room_ke > 0:
#			i.prev_rotation = i.prev_room.custom_rotation
#			i.prev_room = rooms_array[rooms_array.find(i) - 1]
#			i.allign()
#			while i.overlaps.size() > 0:
#				i.allign()
#				print("hmm")
#		else:
#			pass
#func init_allign():
#	while true:
#		if rooms_array[count].room_ke > 0:
#			rooms_array[count].init = true
#			count += 1
#			if count % chunk_size == 0:
#				return

#	for i in rooms_array:
#		if i.room_ke > 0:
#			i.init = true
#			count += 1
#			if count % chunk_size == 0:

#	buffer_timer.start()
#	spot = randi() % 4
#	custom_rotation = randi() % 4
#func return_rotate(value: Vector2, in_rotation: int):
#	var output = value.rotated(in_rotation * PI/2)
#	return output
#	var pos_neg = [1, -1, -1, 1]
#	var vec2_swap = [value.x, value.y]
#	return Vector2(vec2_swap[in_rotation % 2] * pos_neg[in_rotation], vec2_swap[(in_rotation + 1) % 2] * pos_neg[in_rotation - 1])
#	self.global_position = (compass1.global_position) - (return_rotate(compass2.position, custom_rotation))
