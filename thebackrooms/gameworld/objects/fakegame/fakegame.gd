extends Node2D

#export(PackedScene) var ball
#var ball_instance

#func _ready():
#	ball_instance = ball.instance()
#	add_child(ball_instance)
#	ball_instance.global_position = $BallPlayer.global_position


func _on_Goal_body_entered(body):
	if body is RigidBody:
		pass
#		body.queue_free()
