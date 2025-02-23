extends weapon

export(PackedScene) var bullet

func _physics_process(delta):
	if Input.is_action_pressed("left_click") and not $AnimationPlayer.is_playing():
		attack(0)
	target = $cast.get_collider()
#func primary_attack():
#	$AnimationPlayer.play("shoot")
#	var bullet_instance = bullet.instance()
#	get_tree().root.get_child(0).add_child(bullet_instance)
#	bullet_instance.global_position = global_position
#	bullet_instance.global_rotation = global_rotation
#	bullet_instance.dir = (get_global_mouse_position() - global_position).normalized()
func primary_attack():
	$AnimationPlayer.play("shoot")
	if target != null:
		$Particles2D.global_position = $cast.get_collision_point()
		$Particles2D.global_rotation = Vector2.ZERO.angle_to_point($cast.get_collision_normal()) - PI/2.0
		$Particles2D.restart()
		if target is entity:
			summon_popup(target, damage)
			target.damage(damage)
#func apply_buff():
#	recalculate_stats()
#	$AnimationPlayer.set_speed_scale(stat_total.y * 0.1)
#	Global.player.speed = stat_total.z * 20.0
