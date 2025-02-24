extends Spatial

export var relative_direction: Vector3
export var speed_max: float
export var speed_min: float
var origin_pos: Vector3
var selected_speed: float
	
func _ready():
	origin_pos = translation
	selected_speed = rand_range(speed_min, speed_max)
	
func _physics_process(delta):
	translation += selected_speed * delta * relative_direction.normalized()
	if (translation - origin_pos).length() > relative_direction.length():
		translation = origin_pos
		selected_speed = 0.0
		$cool_down.start(rand_range(0.0, 10.0))

func _on_cool_down_timeout():
	selected_speed = rand_range(speed_min, speed_max)
