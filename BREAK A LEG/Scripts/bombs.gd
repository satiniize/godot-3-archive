extends "res://Scripts/entitybase.gd"

onready var player = get_parent().get_node("player")
#onready var breakable = get_parent().get_node("breakable")
var blast = 500

func _on_Area2D_body_entered(body):
	if body != self:
		var bodies = get_parent().get_children()
		for body in bodies:
			if body.get("velocity") and body != self:
				var delta = body.global_position - global_position
				var distance = linear(delta)
				var normal = delta.normalized()
				body.velocity += (blast * normal) * (10000 / pow(distance, 2))
		queue_free()
