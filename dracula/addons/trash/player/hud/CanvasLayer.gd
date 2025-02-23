extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	var pos = $ColorRect.rect_global_position + Vector2($ColorRect.rect_size / 2.0)
	var _vel = get_parent().velocity.rotated(Vector3.UP, -get_parent().rotation.y)
	var vel = Vector2(_vel.x, _vel.z)
	var _dir = get_parent().playerAcceldir.rotated(Vector3.UP, -get_parent().rotation.y)
	var dir = Vector2(_dir.x, _dir.z)
	$Sprite.visible = vel.dot(dir) < 0.0
	draw_circle(pos, get_parent().playerMaxSpeedRun * 16, Color.gray)
	draw_line(pos, pos + vel * 16, Color.red, 8.0)
	draw_line(pos, pos + dir * 16, Color.green, 8.0)

func _physics_process(delta):
	update()
	
