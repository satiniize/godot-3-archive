extends weapon

func _physics_process(delta):
	if Input.is_action_pressed("left_click") and not $AnimationPlayer.is_playing():
		attack(0)
	target = $cast.get_collider()

func primary_attack():
	$AnimationPlayer.play("shoot")
	if target != null:
		$Particles2D.global_position = $cast.get_collision_point()
		$Particles2D.global_rotation = Vector2.ZERO.angle_to_point($cast.get_collision_normal()) - PI/2.0
		$Particles2D.restart()
		if target is entity:
			summon_popup(target, damage)
			target.damage(damage)
