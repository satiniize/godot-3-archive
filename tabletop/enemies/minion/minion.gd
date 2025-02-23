extends LivingBody

export(NodePath) var player_path

var velocity := Vector2.ZERO
export(float) var speed
var dir := Vector2.ZERO
var target_dir := Vector2.ZERO
var player
var flowfield
#var health = 20
var path_progress = 0
#implement boiding
#pack leader?
func _ready():
	add_to_group("enemy")
	randomize()


func _physics_process(delta):
	if player != null:
#		dir = lerp(dir, target_dir, 0.05)
#		drunk_walk()
		dir = dir.normalized()
		velocity = dir * speed
		move_and_slide(velocity, Vector2.ZERO)
		if velocity.x != 0.0:
			$AnimatedSprite.scale.x = (velocity * Vector2(1.0, 0.0)).normalized().dot(Vector2(1.0, 0.0))
#		if is_on_wall():
#			self.modulate = Color.red
#			target_dir = get_last_slide_collision().normal


func drunk_walk(drunkenness=0.2, turn_chance=0.01):
	#maybe pair this with bread crumbing
	if turn_chance >= randf():
		var target = player.global_position
		var offset = target - global_position
		var weight = offset.normalized()
		weight = weight.rotated(rand_range(-PI * drunkenness, PI * drunkenness))
		target_dir = weight.normalized()


func drunk_path(path: PoolVector2Array):
	#pls use horde manager and
	#implement flow fields and Dijkstra's algorithm 
	var player_key
	var self_key
	#oh fuck this is gonna be catasthrophic when the breadcrumb trail is superhigh
	for i in range(path.size()):
		if (path[i] - global_position).length() < (path[self_key] - global_position).length():
			self_key = i
		if (path[i] - player.global_position).length() < (path[player_key] - player.global_position).length():
			player_key = i


func damage(amount : int):
	health -= amount
	if health <= 0:
		die()


func die():
	queue_free()
#	target_dir = (path[min_dist_key] - global_position).normalized()
#		global_position += velocity * delta

#		probe_path.append(tilemap.map_to_world(probe))
	#	if (get_tree().get_frame() + get_instance_id()) % 120 == randi() % 2:
#		dir = get_node(player_path).global_position - global_position
#		dir = dir.normalized()
#		for comrade in get_overlapping_areas():
#			var offset = global_position - comrade.global_position
#			dir += offset.normalized() * 0.5
#		dir = dir.normalized()
	#	while (probe - target).length() > tolerance:
#		var _path_width = path_width
#		if room_chance >= randf():
#			_path_width += randi() % 4 + 8
#		for y in range(_path_width):
#			for x in range(_path_width):
#				var current_cell = tilemap.get_cell(probe.x + x - _path_width / 2, probe.y + y - _path_width / 2)
#				if current_cell == -1:
#					pass
#				tilemap.set_cell(probe.x + x - _path_width / 2, probe.y + y - _path_width / 2, 0)


func _on_Timer_timeout():
	dir = flowfield.get_direction(position)
