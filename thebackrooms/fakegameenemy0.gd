extends KinematicBody2D


export(NodePath) var ball_path
onready var ball = get_node(ball_path)
var velocity : Vector2 = Vector2.ZERO
var speed = 128.0
var idiocy = 0.25

func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2.UP)
	var target_x = -48.0
	if randf() > idiocy and is_on_floor():
		if ball.global_position.x < 0.0:
			target_x = ball.global_position.x - 16.0
			if ball.global_position.y > 32.0:
				velocity.y -= 128.0
	var dir = target_x - global_position.x
	dir = sign(dir)
	velocity.x = speed * dir
	velocity.y += 512.0 * delta
	
