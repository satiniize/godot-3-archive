extends Node2D

var velocity := Vector2.ZERO
	
var input_dict = {}
var accel := 1024.0
#var accel := 2048.0
var damp := 0.1
var hud
enum input{
	ACCEL_DIR
}

func input():
	input_dict[input.ACCEL_DIR] = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()

func movecam():
	$Camera2D.position = velocity / 2.0

func movement(delta: float):
	#accelerate
	velocity += input_dict[input.ACCEL_DIR] * accel * delta
	#damp
	velocity *= pow(damp, delta)
	global_position += velocity * delta

func _physics_process(delta):
	input()
	movement(delta)
#	movecam()
#	if velocity.x != 0.0:
#		$AnimatedSprite.scale.x = (velocity * Vector2(1.0, 0.0)).normalized().dot(Vector2(1.0, 0.0))
	var cam_zoom = Vector2(1.0, 1.0)
	if Input.is_action_pressed("cam_zoom"):
		cam_zoom = Vector2(8.0, 8.0)
#	else:
#		$Camera2D.zoom = Vector2(1.0, 1.0)
	$Camera2D.zoom = lerp($Camera2D.zoom, cam_zoom, 0.25)
	$Sprite.global_position = (get_global_mouse_position() - Vector2(8.0, 8.0)).snapped(Vector2(16.0, 16.0)) + Vector2(8.0, 8.0)
