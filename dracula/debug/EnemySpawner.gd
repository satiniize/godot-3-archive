extends Spatial

export(NodePath) var player_path
onready var player = get_node(player_path)
export(NodePath) var nav_path
onready var nav = get_node(nav_path)
var scene : PackedScene = preload("res://entity/enemy/grunter.tscn")
export(bool) var spawning

func _on_Timer_timeout():
	if spawning:
		var instance = scene.instance()
		get_tree().current_scene.add_child(instance)
		instance.global_transform = global_transform
		instance.player = player
		instance.nav = nav
