extends weapon

func _physics_process(delta):
	target = $cast.get_collider()

func primary_attack():
	$AnimationPlayer.play("stab")
	if target is entity:
		print(target.global_position)
		summon_popup(target, damage)
		target.damage(damage)

func secondary_attack():
	$AnimationPlayer.play("slash")
	for targets in $area.get_overlapping_bodies():
		if targets is entity:
			summon_popup(targets, damage)
			targets.damage(damage)
