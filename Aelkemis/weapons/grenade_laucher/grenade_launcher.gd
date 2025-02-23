extends weapon

export(PackedScene) var grenade_scene
var launch_speed: float = 200.0

func primary_attack():
	animation_node.play("shoot")
	var grenade_instance = grenade_scene.instance()
	get_tree().root.get_child(0).add_child(grenade_instance)
	grenade_instance.global_position = $grenade_spawn.global_position
	grenade_instance.linear_velocity = (get_global_mouse_position() - global_position).normalized() * launch_speed
	grenade_instance.angular_velocity = rand_range(-10.0, 10.0)

func secondary_attack():
	primary_attack()
