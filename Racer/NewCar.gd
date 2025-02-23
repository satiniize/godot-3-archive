extends RigidBody

func _physics_process(delta):
	for i in $Wheels.get_children():
		print((i.saved_pos - i.translation).length())
#	rotation.y += delta
