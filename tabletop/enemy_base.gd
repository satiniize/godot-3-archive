extends Area2D

class_name EnemyBase

export(NodePath) var player_path

var velocity := Vector2.ZERO
export(float) var speed
var dir := Vector2.ZERO
var target_dir := Vector2.ZERO
var player
#implement boiding
#pack leader?
func _ready():
	add_to_group("enemy")
	randomize()


func _physics_process(delta):
	if player != null:
		dir = lerp(dir, target_dir, 0.02)
		drunk_walk()
		velocity = dir * speed
		global_position += velocity * delta
		if velocity.x != 0.0:
			$AnimatedSprite.scale.x = (velocity * Vector2(1.0, 0.0)).normalized().dot(Vector2(1.0, 0.0))


func drunk_walk():
	var drunkenness := 0.1
	var target = player.global_position
	var turn_chance = 0.01
	var offset = target - global_position
	var weight
	if turn_chance >= randf():
		weight = offset.normalized()
		weight = weight.rotated(rand_range(-PI * drunkenness, PI * drunkenness))
		target_dir = weight.normalized()


#		probe_path.append(tilemap.map_to_world(probe))
	
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
#	if (get_tree().get_frame() + get_instance_id()) % 120 == randi() % 2:
#		dir = get_node(player_path).global_position - global_position
#		dir = dir.normalized()
#		for comrade in get_overlapping_areas():
#			var offset = global_position - comrade.global_position
#			dir += offset.normalized() * 0.5
#		dir = dir.normalized()
