extends Area2D

var prev_rot: float
var rot_speed: float

func _ready():
	prev_rot = global_rotation
	rot_speed = global_rotation - prev_rot

func _physics_process(delta):
	rot_speed = global_rotation - prev_rot
	prev_rot = global_rotation
	rot_speed = abs(rot_speed)

func _on_sword_body_entered(body):
	pass
	if body.get("type") == "enemy":
		body.health -= rot_speed * 15.0

