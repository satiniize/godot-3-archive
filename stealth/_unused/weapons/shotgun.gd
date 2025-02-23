extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	if Input.is_action_just_pressed("left_click"):
		for i in get_overlapping_bodies():
			i.die(2000.0 / self.global_position.distance_squared_to(i.global_position))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
