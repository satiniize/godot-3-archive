extends Area2D

signal collected(value)
onready var player = get_parent().get_parent().get_node("Player")
onready var playerhitbox = get_parent().get_parent().get_node("Player/CollDetect/HitBox")
var temporary
func _ready():
	self.connect("collected", player, "_on_Slime_collected")
	var color = Color(randi() % 101 / 100.0, randi() % 101 / 100.0, randi() % 101 / 100.0, 1)
	self.modulate = color
	
func _on_Slime_area_entered(area):
	if area == playerhitbox:
		emit_signal("collected", randi() % 3 + 3)
		queue_free()


func _on_Visibility_screen_exited():
	queue_free()
