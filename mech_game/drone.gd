extends KinematicBody2D

var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta):
	rotation = velocity.x / 512.0
	var diff = (get_global_mouse_position() - global_position)
	velocity = (diff) * 2.0
	velocity = move_and_slide(velocity, Vector2.UP, false, 4, PI/4.0, true)
	global_position += velocity * delta
	$Label.text = str(ceil($lifetime.time_left))
	if is_on_floor() or is_on_wall() or is_on_ceiling():
		queue_free()
		
func _on_lifetime_timeout():
	queue_free()

func _on_drone_body_entered(_body):
	queue_free()
