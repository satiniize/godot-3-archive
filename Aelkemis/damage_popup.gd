extends Label

func _physics_process(delta):
	rect_global_position.y -= 20.0 * delta

func _on_Timer_timeout():
	queue_free()

func tint(percentage: float):
	modulate = Color(1.0, percentage, percentage, 1.0)
