extends Sprite

export var area2d_rotation: float
export var scaler: float = 1.5
export var scripted: bool
export var scripted_velocity: float
export var min_entry: float
export var max_entry: float
onready var player = get_parent().get_node("player")
var direction = Vector2.ZERO

var normallist = {
					"0": Vector2(0, -1),
					"90": Vector2(1, 0),
					"180": Vector2(0, 1),
					"270": Vector2(-1, 0)
					}

func _ready():
	$Area2D.rotation = deg2rad(area2d_rotation)
	direction = Vector2(sin(get_node("Area2D").global_rotation), -cos(get_node("Area2D").global_rotation))
	
func _on_Area2D_body_entered(body):
	if body is KinematicBody2D:
		if !Input.is_action_pressed("crouch"):
			if scripted and body.linear < max_entry and body.linear > min_entry:
				body.global_position = (self.global_position + body.global_position) / 2
				body.global_position = self.global_position
				body.velocity = scripted_velocity * direction
			else:
				body.velocity = body.linear * direction * scaler
		else:
			body.velocity.y = 0
