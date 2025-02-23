extends Area2D

onready var global = get_node("/root/Global")

func _on_end_portal_body_entered(body):
	if body == global.player:
		get_parent().get_tree().reload_current_scene()
