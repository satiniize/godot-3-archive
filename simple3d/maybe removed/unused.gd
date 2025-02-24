#func grab(grab_distance: float):
#	grab_pos = -cast.get_global_transform()[2] * grab_distance + cam_group.translation + translation
#	if Input.is_action_just_released("ui_left_click"):
#		grab_object = null
#	elif Input.is_action_just_pressed("ui_left_click") and cast.get_collider() is RigidBody:
#		grab_object = cast.get_collider()
#	elif Input.is_action_pressed("ui_left_click") and grab_object != null:
#		var grab_object_distance = grab_object.translation - grab_pos
#		grab_object.set_linear_velocity(-grab_object_distance * 16 + velocity)
#	elif cast_object is RigidBody:
#		grab_pos = -cast.get_global_transform()[2] * 2.0 + cam_group.translation + translation
#		if Input.is_action_just_released("ui_left_click"):
#			grab_object = null
#		elif Input.is_action_just_pressed("ui_left_click") and cast.get_collider() is RigidBody:
#			grab_object = cast.get_collider()
#		elif Input.is_action_pressed("ui_left_click") and grab_object != null:
#			grab_object.translate(grab_pos - grab_object.tra)
#			var grab_object_distance = grab_object.translation - grab_pos
#			grab_object.set_linear_velocity(-grab_object_distance * 16 + velocity)
#		if cast_object is Interactable and bool(Global.left_click):
#			rotation.y = camera_clamp.y
#			cam_group.rotation.x = camera_clamp.x
#		else:
#func _process(delta):
#	if not needs_interaction:
#		anim.play("idle")
#
#func interact(left_click, delta):
#	if needs_interaction:
#		anim.play("plunging")
#		.interact(left_click, delta)

func _ready():
	pass # Replace with function body.
