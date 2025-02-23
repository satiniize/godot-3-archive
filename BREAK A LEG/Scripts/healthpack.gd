extends Area2D

onready var player = get_parent().get_node("player")


func _on_healthpack_body_entered(body):
	if body == player:
		player.health += 25
