extends weapon

func _physics_process(delta):
	if (Input.is_action_just_pressed("left_click") or Input.is_action_just_pressed("right_click")) and not $AnimationPlayer.is_playing():
		attack(0)
#	apply_buff()
func primary_attack():
	$AnimationPlayer.play("swing")
	for i in $Area2D.get_overlapping_bodies():
		if i != null:
			summon_popup(i, damage)
			i.damage(damage)
#	
#func apply_buff():
#	recalculate_stats()
#	$AnimationPlayer.set_speed_scale(stat_total.y * 0.1)
#	Global.player.speed = stat_total.z * 20.0
