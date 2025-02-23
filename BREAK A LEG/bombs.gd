extends "res://Scripts/entitybase.gd"

onready var player = get_parent().get_node("player")
var blast = 500
func _ready():
	$lifetime.start()


func _on_lifetime_timeout():
	var delta = player.global_position - global_position
	var distance = pow(pow(delta.x, 2) + pow(delta.y, 2), 0.5)
	var normal = delta.normalized()
#	var distance = Vector2(100, 100) / (self.global_position.distance_to(player.global_position))
	player.velocity += (blast * normal) * (10000 / pow(distance, 2))
	queue_free()
