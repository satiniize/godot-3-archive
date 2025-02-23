extends Node2D

var cost_field : PoolIntArray
var integration_field : PoolIntArray
var flow_field : Dictionary

var used_rect : Rect2
var unvisited_nodes : Array
var future_unvisited_nodes : Array

#position
#size

#var update_distance = 16

func set_cost(x : int, y : int, cost : float):
	cost_field[y*used_rect.size.x + x] = cost

#func inside_update_distance(target_tile_id : int, neighbor_tile_id : int) -> bool:
#	var target_tile_x : int = target_tile_id % int(used_rect.size.x)
#	var target_tile_y : int = floor(target_tile_id / used_rect.size.x)
#	var neighbor_tile_x : int = neighbor_tile_id % int(used_rect.size.x)
#	var neighbor_tile_y : int = floor(neighbor_tile_id / used_rect.size.x)
#	return (
#		neighbor_tile_x > (target_tile_x - update_distance) and
#		neighbor_tile_x < (target_tile_x + update_distance) and
#		neighbor_tile_y > (target_tile_y - update_distance) and
#		neighbor_tile_y < (target_tile_y + update_distance)
#	)

func get_neighbor(tile_id : int) -> Array:
	var neighbors : Array
	for i in range(2):
		var mod = i*2 - 1
		var neighbor_x = tile_id + 1*mod
		var neighbor_y = tile_id + used_rect.size.x*mod
		if neighbor_x >= 0 and neighbor_x < used_rect.size.x*used_rect.size.y:
			neighbors.append(neighbor_x)
		if neighbor_y >= 0 and neighbor_y < used_rect.size.x*used_rect.size.y:
			neighbors.append(neighbor_y)
		
#		if (neighbor_x % int(used_rect.size.x) > (target_id % int(used_rect.size.x) - update_distance) and
#			neighbor_x % int(used_rect.size.x) < (target_id % int(used_rect.size.x) + update_distance)):
#			neighbors.append(neighbor_x)
#		if (floor(neighbor_y / used_rect.size.x) > (floor(target_id / used_rect.size.x) - update_distance) and
#			floor(neighbor_y / used_rect.size.x) < (floor(target_id / used_rect.size.x) + update_distance)):
#			neighbors.append(neighbor_y)
	return neighbors

func init_cost():
	for id in range(used_rect.size.x*used_rect.size.y):
		cost_field.append(1024.0) #muchos idiotas

func init_integration():
	integration_field.resize(0)
	for id in range(used_rect.size.x*used_rect.size.y):
		integration_field.append(1024.0) #muchos idiotas

#func reset_field(target_tile : int):
#	for y in range(2*update_distance + 1):
#		for x in range(2*update_distance + 1):
#			var y_offset = (y - update_distance) * used_rect.size.y
#			var x_offset = x - update_distance
#			var cur = target_tile + y_offset + x_offset
#			integration_field[cur] = 255.0

func generate_integration_field(target_pos : Vector2):
	var target_tile = target_pos / 16.0 - used_rect.position
	target_tile = target_tile.floor()
	var target_id = target_tile.y*used_rect.size.x + target_tile.x
#	reset_field(target_id)
	integration_field[target_id] = 0.0
	unvisited_nodes.push_front(target_id)
	var count = 0
	var steps = 1
	while unvisited_nodes.size() > 0:
		var cur_id : int = unvisited_nodes.pop_front()
		var cur_y : int = floor(cur_id / used_rect.size.x)
		var cur_x : int = cur_id % int(used_rect.size.x)
		var neighbors = get_neighbor(cur_id)
		for neighbor_id in neighbors:
			var cost = cost_field[neighbor_id] + integration_field[cur_id]
			if cost < integration_field[neighbor_id]:
				integration_field[neighbor_id] = cost
				if not neighbor_id in unvisited_nodes:
					future_unvisited_nodes.append(neighbor_id)
		count += 1
	unvisited_nodes = future_unvisited_nodes

func _physics_process(delta):
	update()

func get_direction(pos) -> Vector2:
	var tile_pos = pos / 16.0 - used_rect.position
	var tile_id = tile_pos.y*used_rect.size.x + tile_pos.x
	var dir : Vector2
	print(integration_field[min(tile_id + 1, used_rect.size.x*used_rect.size.y - 1)] - integration_field[max(tile_id - 1, 0)])
	dir.x = integration_field[min(tile_id + 1, used_rect.size.x*used_rect.size.y - 1)] - integration_field[max(tile_id - 1, 0)]
	print(integration_field[min(tile_id + used_rect.size.x, used_rect.size.x*used_rect.size.y - 1)] - integration_field[max(tile_id - used_rect.size.x, 0)])
	dir.y = integration_field[min(tile_id + used_rect.size.x, used_rect.size.x*used_rect.size.y - 1)] - integration_field[max(tile_id - used_rect.size.x, 0)]
	return -dir.normalized()

func _draw():
	for id in range(used_rect.size.x*used_rect.size.y):
		var x = id % int(used_rect.size.x) + used_rect.position.x
		var y = floor(id / used_rect.size.x) + used_rect.position.y
		var pos = Vector2(x * 16.0, y * 16.0)
#		var rect = Rect2(Vector2(x * 16.0, y * 16.0), Vector2(16.0, 16.0))
#		if integration_field.size() > id:
#			draw_line(pos, pos + get_direction(pos) * 16.0, Color.white)

#			draw_rect(rect, Color.red * integration_field[id] / 10.0)
