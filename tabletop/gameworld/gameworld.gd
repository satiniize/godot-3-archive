extends Node2D


class PlayerData:
	var inventory = {}
	var held_item_id


var path: PoolVector2Array
var probe_path: PoolVector2Array
onready var tilemap = get_node("Navigation2D/TileMap")
var player_scene = preload("res://player/player.tscn")
#var gamemaster = preload("res://player/gamemaster/gamemaster.tscn")
#var warrior = preload("res://player/warrior/warrior.tscn")
var player_data = {}
var level: int = 1
var player_ref
#var dropped_item = preload("res://player/weapons/dropped_item.tscn")
#var item_data = preload("res://player/weapons/item_data.tres")
#var hud

signal finished_setup

func _ready():
	self.connect("finished_setup", get_node("EnemyManager"), "finished_setup")
	self.connect("finished_setup", get_node("FlowField"), "finished_setup")
	
#	randomize()
	seed(Network.map_seed)
	generate_level()
	spawn_players()
	
	emit_signal("finished_setup")
#	for i in range(5):
#		var enemy_instance = load("res://enemies/minion/minion.tscn").instance()
#		enemy_instance.player
func spawn_players():
	var player_ids = Network.roles.keys()
#	hud = load("res://ui/hud/hud.tscn").instance()
#	hud.mode = Network.roles[get_tree().get_network_unique_id()]
	print(Network.roles)
	for player in player_ids:
		var player_instance = player_scene.instance()
		player_instance.role = Network.roles[player]
		$Players.add_child(player_instance)
		player_ref = player_instance
		player_instance.set_network_master(player)
		if player == get_tree().get_network_unique_id():
			$HUD.player = player_instance

func generate_level():
	tilemap.clear()
	#declare shit
	var target_distance = 2048.0
	var spread = 0.8
	var origin = tilemap.world_to_map(Vector2.ZERO)
	var rot = rand_range(0.0, 2.0*PI)
	var target = tilemap.world_to_map(Vector2(cos(rot), sin(rot)) * target_distance)
	var probe = origin
	var turn_chance = 0.15
	var path_width: int = 6
	var weight : Vector2
	var room_chance = 0.05
	var tolerance = 10
	
#	var _path_width = path_width
#	_path_width += 2
#	if room_chance >= randf() or (probe - target).length() <= tolerance:
#		_path_width += (randi() % 4) * 2 + 8
#	for y in range(_path_width):
#		for x in range(_path_width):
#			var current_cell = tilemap.get_cell(probe.x + x - _path_width / 2, probe.y + y - _path_width / 2)
#			if current_cell == -1:
#				pass
#			if (
#				x % _path_width == 0 or
#				x % _path_width == _path_width - 1 or
#				y % _path_width == 0 or
#				y % _path_width == _path_width - 1
#			):
#				if current_cell != 0:
#					tilemap.set_cell(probe.x + x - _path_width / 2, probe.y + y - _path_width / 2, 1)
#					$FlowField.set_cost(probe.x + x - _path_width / 2, probe.y + y - _path_width / 2, 0.0)
#			else:
#				tilemap.set_cell(probe.x + x - _path_width / 2, probe.y + y - _path_width / 2, 0)
#				$FlowField.set_cost(probe.x + x - _path_width / 2, probe.y + y - _path_width / 2, 1.0)
	
	
	#iterate
	while (probe - target).length() > tolerance:
		var offset = target - probe
		if turn_chance >= randf():
			weight = offset.normalized()
			weight = weight.rotated(rand_range(-PI * spread, PI * spread))
			probe_path.append(tilemap.map_to_world(probe))
		probe += weight.round()
		
		var _path_width = path_width
		_path_width += 2
		if room_chance >= randf() or (probe - target).length() <= tolerance:
			_path_width += (randi() % 4) * 2 + 6
		for y in range(_path_width):
			for x in range(_path_width):
				var current_cell = tilemap.get_cell(probe.x + x - _path_width / 2, probe.y + y - _path_width / 2)
				if current_cell == -1:
					pass
				if (
					x % _path_width == 0 or
					x % _path_width == _path_width - 1 or
					y % _path_width == 0 or
					y % _path_width == _path_width - 1
				):
					if current_cell != 0:
						tilemap.set_cell(probe.x + x - _path_width / 2, probe.y + y - _path_width / 2, 1)
				else:
					tilemap.set_cell(probe.x + x - _path_width / 2, probe.y + y - _path_width / 2, 0)
	
	probe_path.append(tilemap.map_to_world(probe))
	tilemap.update_bitmask_region()
	$Interactables/Finish.global_position = tilemap.map_to_world(probe)
	var tilemap_rect = tilemap.get_used_rect()
	$FlowField.used_rect = tilemap_rect
	$FlowField.init_cost()
	$FlowField.init_integration()
	for id in range(int(tilemap_rect.size.x*tilemap_rect.size.y)):
		var x : int = id % int(tilemap_rect.size.x)
		var y : int = floor(id / tilemap_rect.size.x)
		var tile_id = tilemap.get_cell(x + tilemap_rect.position.x, y + tilemap_rect.position.y)
		if tile_id == 0:
			$FlowField.set_cost(x, y, 1.0)

func increment_level():
	level += 1
	generate_level()
	for warrior in $Warriors.get_children():
		warrior.global_position = Vector2.ZERO
	for gamemaster in $GameMasters.get_children():
		gamemaster.global_position = Vector2.ZERO


func _physics_process(delta):
	if Input.is_action_just_pressed("debug"):
		increment_level()
#	$FlowField.generate_integration_field(player_ref.global_position)
	$FlowField.generate_integration_field(player_ref.global_position)
	update()


func _draw():
	if $Warriors.get_child_count() > 0:
		var breadcrumbs = $Warriors.get_child(0).breadcrumbs
		if len(breadcrumbs) > 1:
			draw_polyline(breadcrumbs, Color.red)
	draw_polyline(probe_path, Color.blue)

func _on_Finish_body_entered(body):
	$IncrementTimer.start()
	$AnimationPlayer.play("transition")


func _on_IncrementTimer_timeout():
	increment_level()
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
#func _draw():
#	for index in range(len(probe_path)):
#		draw_circle(probe_path[index], 8.0, Color.blue)
#		if index != 0:
#			draw_line(probe_path[index], probe_path[index - 1], Color.gray, 8.0)


	#item debug
#	var item_instance1 = dropped_item.instance()
#	item_instance1.position += Vector2.ZERO
#	item_instance1.id = "dagger"
#	$Items.add_child(item_instance1)
#
#	var item_instance2 = dropped_item.instance()
#	item_instance2.position += Vector2.ZERO
#	item_instance2.id = "heal_pot"
#	$Items.add_child(item_instance2)
#
#	item_instance2 = dropped_item.instance()
#	item_instance2.position += Vector2.ZERO
#	item_instance2.id = "broadsword"
#	$Items.add_child(item_instance2)
#		match Network.roles[player]:
#			Network.Role.GAMEMASTER:
#				player_instance = gamemaster.instance()
#				$GameMasters.add_child(player_instance)
#			Network.Role.WARRIOR:
#				player_instance = warrior.instance()
#				$Warriors.add_child(player_instance)
#				player_data[player] = PlayerData.new()
#			hud.player = player_instance
#			player_instance.hud = hud
	
#	get_tree().current_scene.add_child(hud)

