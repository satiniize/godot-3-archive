extends Enemy

var target_pos : Vector3
var charge_pos : Vector3
var charging : bool = false
#var velocity : Vector3 = Vector3.ZERO

func _ready():
	pass #CAR CAR CAR CAR Car

func _physics_process(delta):
	move_and_slide(velocity, Vector3.UP)
	velocity.y -= 16.0 * delta
	if charging and not is_on_wall():
		var _dist = charge_pos - target_pos
		if (charge_pos - global_transform.origin).length() > _dist.length() + 8.0:
			charging = false
			velocity = Vector3.ZERO
	else:
		var space_state = get_world().direct_space_state
		var offset = Vector3(0.0, 1.0, 0.0)
		var result = space_state.intersect_ray(global_transform.origin + offset, player.global_transform.origin + offset, [self])
		if result and $Charge.is_stopped():
			$Charge.start()


func _on_Charge_timeout():
	var _dir = player.global_transform.origin - global_transform.origin
	_dir.y = 0.0
	_dir = _dir.normalized()
	velocity = _dir * 32.0
	charging = true
	target_pos = player.global_transform.origin
	charge_pos = global_transform.origin
