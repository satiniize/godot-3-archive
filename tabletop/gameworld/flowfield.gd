extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var direction_map = {}
var age_map = {} #get direction from age direction
var can_draw = false
# Called when the node enters the scene tree for the first time.
var cell_size = 3.0
var stench_radius = 3.0
#func _ready():
#	generate_age_map()
var decay_constant = 0.05

func _physics_process(delta):
	increment_age_map(delta)
	update()


func generate_field():
	var warrior = get_parent().get_node("Warriors").get_child(0)
	var target_x = int(floor(warrior.global_position.x))
	var target_y = int(floor(warrior.global_position.y))
	var size: Rect2 = get_parent().get_node("Navigation2D/TileMap").get_used_rect()
	var cell_size = 2.5
	var size_x = floor(size.size.x / cell_size)
	var size_y = floor(size.size.y / cell_size)
	for y in range(size_y):
		for x in range(size_x):
			if get_parent().get_node("Navigation2D/TileMap").get_cell(x, y) == 0:
				if not direction_map.has(y):
					direction_map[y] = {}
				if not direction_map[y].has(x):
					direction_map[y][x] = Vector2.ZERO


func generate_age_map():
	var rect: Rect2 = get_parent().get_node("Navigation2D/TileMap").get_used_rect()
	var size_x = floor(rect.size.x / cell_size)
	var size_y = floor(rect.size.y / cell_size)
	for y in range(size_y):
		for x in range(size_x):
			if not age_map.has(y):
				age_map[y] = {}
			age_map[y][x] = 1.0


func increment_age_map(delta):
	var rect: Rect2 = get_parent().get_node("Navigation2D/TileMap").get_used_rect()
	var size_x = floor(rect.size.x / cell_size)
	var size_y = floor(rect.size.y / cell_size)
	for y in range(size_y):
		for x in range(size_x):
			if not age_map.has(y):
				age_map[y] = {}
			if not age_map[y].has(x):
				age_map[y][x] = 1.0
			if age_map[y][x] < 1.0:
				age_map[y][x] += delta * decay_constant
	var target = get_parent().get_node("Warriors").get_child(0)
	var target_x : int = floor((target.global_position.x / 16.0 / cell_size) - rect.position.x / cell_size)
	var target_y : int = floor((target.global_position.y / 16.0 / cell_size) - rect.position.y / cell_size)
	for _y in range(stench_radius * 2 + 1):
		for _x in range(stench_radius * 2 + 1):
#			var value = float(abs(_x - stench_radius) + abs(_y - stench_radius)) / float(2 * stench_radius) / 4.0
			var value = (stench_radius*stench_radius - (_x - stench_radius)*(_x - stench_radius) - (_y - stench_radius)*(_y - stench_radius)) / float(stench_radius*stench_radius) / 64.0
			if age_map[int(clamp(target_y + _y - stench_radius, 0, size_y - 1))][int(clamp(target_x + _x - stench_radius, 0, size_x - 1))] > 0:
				age_map[int(clamp(target_y + _y - stench_radius, 0, size_y - 1))][int(clamp(target_x + _x - stench_radius, 0, size_x - 1))] -= value
#			if get_parent().get_node("Navigation2D/TileMap").get_cell(x, y) == 0:
#				pass


func _draw():
	var rect: Rect2 = get_parent().get_node("Navigation2D/TileMap").get_used_rect()
	var size_x = floor(rect.size.x / cell_size)
	var size_y = floor(rect.size.y / cell_size)
	var rect4draw : Rect2 = Rect2(rect.position, Vector2(cell_size, cell_size) * 16.0)
	for y in range(size_y):
		for x in range(size_x):
			rect4draw.position = rect.position * 16.0 + Vector2(x, y) * 16.0 * cell_size
			var value = 1.0 - age_map[y][x]
			draw_rect(rect4draw, Color(value * 0.5, value, value * 0.2, 0.5))

func finished_setup():
	increment_age_map(1.0 / 120.0)
#	for warrior in get_parent().get_node("Warriors").get_children():
#		pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
