extends Node2D

export var finish_portal: PackedScene
export var variant1: PackedScene
export var variant2: PackedScene
export var variant3: PackedScene
export var variant4: PackedScene
export var variant5: PackedScene
export var enemy1: PackedScene
export var heal: PackedScene
export var nav_path: NodePath
onready var rooms = get_node("rooms")
enum{NORTH, WEST, EAST, SOUTH}
var overlapped = false
var finished_generating = false
var jumlah_level = 0
var rooms_array: Array
var chunk_size = 5
var count = 0
var portal
var theme: Color
var super_tiles: Array
onready var global = get_node("/root/Global")
onready var cooldown = get_node("world_cooldown")

signal summon(value, type)

func _ready():
	randomize()
	global.room_nav = $rooms
	theme = Color(float(randi() % 11 + 10) / 100.0, float(randi() % 11 + 10) / 100.0, float(randi() % 11 + 10) / 100.0)
	global.player = $player
	jumlah_level = randi() % 5 + 10
	var inverse = Color.white - theme
	global.player.modulate = theme.inverted()
	global.player.get_node("vision").shadow_color.r = theme.r * 0.102
	global.player.get_node("vision").shadow_color.b = theme.b * 0.102
	global.player.get_node("vision").shadow_color.g = theme.g * 0.102
	generate(jumlah_level)
	
	
func _process(delta):
	VisualServer.set_default_clear_color(theme * 0.102)
	$rooms/test.material.set_shader_param("color", theme)
#	check_theme_brightness(theme)
#	if Input.is_action_just_pressed("debug"):
#
		
	if Input.is_action_just_pressed("dash"):
		get_tree().reload_current_scene()

#func check_theme_brightness(value: Color):
#	var brightness = (value.r * 0.333) + (value.g * 0.333) + (value.b * 0.333)
#	if brightness < 0.1 or brightness > 0.2:
#		theme = Color(float(randi() % 11 + 10) / 100.0, float(randi() % 11 + 10) / 100.0, float(randi() % 11 + 10) / 100.0)
	
func generate(length: int) -> void:
	var prev_room
	for i in range(0, length):
		var instance
		instance = self.get("variant" + str(randi() % 5 + 1)).instance()
		$room_setup.add_child(instance)
		instance.room_ke = i
		if i == 0: 
			instance.global_position = Vector2.ZERO
			instance.custom_rotation = 0
			$player.global_position = instance.safe_spot.global_position
		else:
			instance.prev_room = prev_room
			instance.prev_rotation = prev_room.custom_rotation
			instance.init = true
		prev_room = instance
		rooms_array.append(instance)

func reset_cooldown(value: int):
	if value > 0:
		cooldown.start(value)
	else:
		cooldown.start()

func _on_cooldown_timeout():
	finished_generating = true
	portal = finish_portal.instance()
	rooms.add_child(portal)
	portal.global_position = rooms_array[jumlah_level - 1].safe_spot.global_position
	$enemy_spawn.start()
	for i in rooms_array:
		for j in i.tilearray:
			if j[1] != -1:
				$rooms/test.set_cell(int(round(j[0].x)), int(round(j[0].y)), j[1], randbool(), randbool())
	
func _on_enemy_spawn_timeout():
	var random = randi() % 4
	if random == 0:
		emit_signal("summon", heal, 1)
	else:
		emit_signal("summon", enemy1, 0)

func randbool():
	var value = randi() % 2
	if value == 1:
		return true
	else:
		return false
#			if i == length - 1:
#				portal = finish_portal.instance()
#				rooms.add_child(portal)
#				portal.global_position = instance.safe_spot.global_position
