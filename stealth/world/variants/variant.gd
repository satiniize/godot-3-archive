extends TileMap

export var safe_area: Vector2
onready var north = get_node("north")
onready var south = get_node("south")
onready var west = get_node("west")
onready var east = get_node("east")
onready var safe_spot = get_node("safe_area")
onready var end_portal = preload("res://world/end_portal.tscn")
var init = false
var custom_rotation = 0
var rotation_normal: Array = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
enum{NORTH, SOUTH, WEST, EAST}
onready var source: Array = [east, south, west, north]
onready var target: Array = [west, north, east, south]
var prev_room
var spot
var prev_rotation
var compass1
var compass2
var room_ke = 0
var enemy_count = 0
var tilearray: Array

func _ready():
	randomize()
	spot = randi() % 4
	custom_rotation = randi() % 4
	get_parent().get_parent().connect("summon", self, "summon_enemy")
	tile_variance()

func _process(delta):
	material.set_shader_param("color", get_parent().get_parent().theme)
	if get_parent().get_parent().get_node("world_cooldown").time_left < 0.5 and !get_parent().get_parent().finished_generating:
		create_opening(prev_room)
		tile2vec2array()
	if init:
		prev_rotation = prev_room.custom_rotation
		allign()
		for i in $overlap.get_overlapping_areas():
			if room_ke > i.get_parent().room_ke:
				spot = randi() % 4
				custom_rotation = randi() % 4 ##NEEDS FIXING SOMEHOW
				get_parent().get_parent().reset_cooldown(0)
		init = !get_parent().get_parent().finished_generating
		print("bruh")

func allign() -> void:
	compass1 = prev_room.target[(spot + custom_rotation) % 4]
	compass2 = self.source[(spot + prev_rotation) % 4]
	self.global_position = (compass1.global_position) - (compass2.position.rotated(custom_rotation * PI/2))
	self.global_rotation = PI/2 * custom_rotation

func create_opening(target1: TileMap):
	if room_ke > 0:
		for y in range(int(compass1.position.y) / 8 - 1, int(compass1.position.y) / 8 + 1):
			for x in range(int(compass1.position.x) / 8 - 1, int(compass1.position.x) / 8 + 1):
				target1.set_cell(x, y, randi() % 5)
		if room_ke < get_parent().get_parent().jumlah_level:
			for y in range(int(compass2.position.y) / 8 - 1, int(compass2.position.y) / 8 + 1):
				for x in range(int(compass2.position.x) / 8 - 1, int(compass2.position.x) / 8 + 1):
					set_cell(x, y, randi() % 5)

func summon_enemy(enemy: PackedScene, type: int):
	if enemy_count <= 3:
		var x = int(rand_range(0, safe_area.x))
		var y = int(rand_range(0, safe_area.y))
		if get_cell(x, y) != -1 and get_cell(x, y) != 5:
			var instance = enemy.instance()
			instance.variant_parent = self
			get_parent().get_parent().get_node("enemies").add_child(instance)
			instance.global_position = global_position + Vector2(x * 8 + 4, y * 8 + 4).rotated(custom_rotation * PI/2)
			enemy_count += 1

func tile_variance():
	for y1 in range(0, safe_area.y):
		for x1 in range(0, safe_area.x):
			if get_cell(x1, y1) != -1 and get_cell(x1, y1) != 5:
				var chance = randi() % 2
				if chance == 0:
					set_cell(x1, y1, randi() % 4)
				set_cell(x1, y1, get_cell(x1, y1))

func tile2vec2array():
	for y1 in range(0, safe_area.y):
		for x1 in range(0, safe_area.x):
			tilearray.append([Vector2(x1 + 0.5, y1 + 0.5).rotated(custom_rotation * PI/2) + global_position / 8.0 - Vector2(0.5, 0.5), get_cell(x1, y1)])

func roundvec2(value: Vector2):
	return Vector2()
