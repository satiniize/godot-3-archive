extends Node

var seperation_weight = 0.5

export(NodePath) var player_path
onready var player = get_node(player_path)

func _ready():
	for child in get_children():
		child.player = player

#func _physics_process(delta):
#	for i in range(get_child_count()):
#		var new_dir : Vector3
#		var enemy = get_child(i)
#		for j in range(get_child_count()):
#			var other = get_child(j)
#			if other != enemy:
#				var distance = enemy.global_transform.origin - other.global_transform.origin
#				if distance.length() < 32.0:
#					new_dir += distance.normalized() * seperation_weight / distance.length_squared()
#		if new_dir.length() < 32.0:
#			enemy.dir = new_dir.normalized()
#		else:
#			enemy.dir = Vector3.ZERO
