extends KinematicBody

export(NodePath) var marker
var saved_pos: Vector3 = Vector3.ZERO

func _ready():
	saved_pos = translation

func _physics_process(delta):
	var collision = move_and_collide(Vector3(0.0, -9.8 * delta, 0.0), true)
#	if collision != null:
#		print(collision.position)
