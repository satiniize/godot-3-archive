extends Node2D


var path: PoolVector2Array
var probe_path: PoolVector2Array


func _ready():
	randomize()
	generate_level()
	$WarriorHUD.player = $Warrior
	$WarriorHUD.end_goal = $End


func _draw():
	for index in range(len(probe_path)):
		draw_circle(probe_path[index], 8.0, Color.blue)
		if index != 0:
			draw_line(probe_path[index], probe_path[index - 1], Color.gray, 8.0)


func generate_level():
	#declare shit
	var target_distance = 2048.0
	var spread = 0.8
	var origin = $Navigation2D/FloorTiles.world_to_map(Vector2.ZERO)
	var rot = rand_range(0.0, 2.0*PI)
	var target = $Navigation2D/FloorTiles.world_to_map(Vector2(cos(rot), sin(rot)) * target_distance)
	var probe = origin
	var turn_chance = 0.15
	var path_width: int = 6
	var weight : Vector2
	var room_chance = 0.05
	var tolerance = 10
	
	#iterate
	while (probe - target).length() > tolerance:
		var _path_width = path_width
		if room_chance >= randf():
			_path_width += randi() % 4 + 8
		for y in range(_path_width):
			for x in range(_path_width):
				var current_cell = $Navigation2D/FloorTiles.get_cell(probe.x + x - _path_width / 2, probe.y + y - _path_width / 2)
				if current_cell == -1:
					pass
				$Navigation2D/FloorTiles.set_cell(probe.x + x - _path_width / 2, probe.y + y - _path_width / 2, 0)
		var offset = target - probe
		if turn_chance >= randf():
			weight = offset.normalized()
			weight = weight.rotated(rand_range(-PI * spread, PI * spread))
			probe_path.append($Navigation2D/FloorTiles.map_to_world(probe))
		probe += weight.round()
	
	
	$End.global_position = $Navigation2D/FloorTiles.map_to_world(probe - weight.round())
	$Navigation2D/FloorTiles.update_bitmask_region()

func _physics_process(delta):
	if Input.is_action_just_pressed("debug"):
		get_tree().reload_current_scene()


	#seeds
	#buttsex actually makes a decent one with shit end
#	seed(hash("peepeepoopoo"))
#		_path_width += 2
	#	for point in path:
#		draw_circle(point, 16.0, Color.orangered)
#	for index in range(len(path)):
#		draw_circle(path[index], 8.0, Color.orangered)
#		if index != 0:
#			draw_line(path[index], path[index - 1], Color.white, 8.0)

#	print(get_tree().get_nodes_in_group("enemy"))
	
#func summon_enemy(type: int, amount: int = 1):
#	pass
#	var is_even = path_width % 2 == 0
			
#		var direction = Vector2.RIGHT
#		var turn_weight = 1.0 - direction.dot((target - probe).normalized())
#		if turn_chance >= randf():
#			direction = direction.rotated(turn_weight * PI/2)
#		$TileMap.set_cell(probe.x, probe.y, 0)
			#				if is_even:
#					pass
#				else:
#					pass
#		probe += direction.round()
#		print(probe, turn_weight)
	#implement path first then add rooms

#var grid = [
#	[0, 0, 0, 0, 0, 0, 0, 0],
#	[0, 0, 0, 0, 0, 0, 0, 0],
#	[0, 0, 0, 0, 0, 0, 0, 0],
#	[0, 0, 0, 0, 0, 0, 0, 0],
#	[0, 0, 0, 0, 0, 0, 0, 0],
#	[0, 0, 0, 0, 0, 0, 0, 0],
#	[0, 0, 0, 0, 0, 0, 0, 0],
#	[0, 0, 0, 0, 0, 0, 0, 0],
#]
#	if not len(path) > 0:
#		path = $Navigation2D.get_simple_path(Vector2.ZERO, $End.global_position, true)
#	if get_tree().get_frame() % 120 == 0:
#		path = $Navigation2D.get_simple_path($Warrior.global_position, $End.global_position, true)
