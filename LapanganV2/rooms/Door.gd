extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var is_open: = false
# Called when the node enters the scene tree for the first time.
#func _ready():
#	$AnimationPlayer.play("Open")

func toggle_door(value: bool):
	if is_open == value:
		return
	else:
		is_open = value
		if !is_open:
			$AnimationPlayer.play("Close")
		else:
			$AnimationPlayer.play("Open")

func _on_Timer_timeout():
	pass
#	toggle_door(!is_open)
