extends entity

class_name enemy
var dir = 1.0
export(PackedScene) var projectile
export(float) var damage

func _ready():
	speed = 50.0
	velocity.x = speed
	
func _physics_process(delta):
	if is_on_wall():
		dir *= -1
		velocity.x = dir * speed
	velocity.y += gravity * delta
	if randi() % 60 == 1 and is_on_floor():
		velocity.y -= 100.0
	$sprite.scale.x = dir

func _on_shoot_rest_timeout():
	var projectile_instance = projectile.instance()
	projectile_instance.damage = damage
	get_tree().root.get_child(0).add_child(projectile_instance)
	projectile_instance.global_position = global_position
	projectile_instance.linear_velocity = (Global.player.global_position - global_position).normalized() * 300.0
	$shoot_rest.wait_time = rand_range(2.0, 5.0)
