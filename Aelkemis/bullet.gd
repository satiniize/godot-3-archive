extends Area2D

var speed: float = 256.0
var dir: Vector2 = Vector2.ZERO

func _physics_process(delta):
	if dir.length() > 0.0:
		global_position += delta * speed * dir

func _on_bullet_body_entered(body):
	body.queue_free()
	queue_free()


func _on_life_time_timeout():
	queue_free()
