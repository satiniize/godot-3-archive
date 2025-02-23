extends Area2D

var type = "heal"
var variant_parent

func _on_heal_body_entered(body):
	variant_parent.enemy_count -= 1
	body.heal()
	queue_free()
