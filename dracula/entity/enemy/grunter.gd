extends Enemy

class_name Grunter

export(NodePath) var nav_path
onready var nav = get_node(nav_path)
var dir : Vector3
var base_dir : Vector3


func _ready():
	add_to_group("enemies")

#func check_step():
#	var space_state = get_world().direct_space_state
#	var pos = global_transform.origin
#	var v_offset = Vector3.UP * 1.0
#	var h_offset = velocity.normalized()
#	var step_tolerance = 0.5
#	var result = space_state.intersect_ray(pos + h_offset + v_offset, pos + h_offset + step_tolerance * Vector3.DOWN, [self])
#	if result:
#		return true
#	else:
#		false

func simple_path_find(pos : Vector3):
	var dir = pos - global_transform.origin
	dir.y = 0.0
	return dir.normalized()

func get_path_dir(pos : Vector3):
	var path = nav.get_simple_path(global_transform.origin, pos)
	var dir = Vector3.ZERO
	if path.size() > 0:
		dir = path[1] - path[0]
		var _dist = (path[path.size() - 1] - path[0]).length()
		if _dist < 1.0:
			dir = -dir * (1.0 - _dist)
	dir = dir.normalized()
	return dir

func _physics_process(delta):
	if player != null and nav != null:
		#search for nearby friends
		var params = PhysicsShapeQueryParameters.new()
		var shape = CylinderShape.new()
		var max_radius = 8.0
		var min_radius = 1.0
		shape.radius = max(max_radius * (100.0 - health) / 100.0, min_radius)
		shape.height = 4.0
		params.set_shape(shape)
		params.transform = global_transform
		var space_state = get_world().direct_space_state
		var results = space_state.intersect_shape(params)
		
		#movement precalc
		var _dir : Vector3 = Vector3.ZERO
#		_dir += get_path_dir(player.global_transform.origin) * 1.2
		if not asleep:
			_dir += simple_path_find(player.global_transform.origin) * 1.2
		_dir += sep(results)
		_dir = _dir.normalized()	
		velocity.y -= 9.8 * delta
		var damp = pow(0.1, delta)
		velocity.x *= damp
		velocity.z *= damp
		
		#movement
		if velocity.length() < max_speed:
			velocity += _dir * accel * delta
		if check_step():
			velocity = move_and_slide(velocity, Vector3.UP)
		if _dir.length() > 0.0:
			orient(_dir, delta)

#maintain arbitrary distance from friends
func sep(results : Array):
	var sep_dir : Vector3
	for result in results:
		var collider = result["collider"]
		if collider != self and collider is Entity:
			var _dist = self.global_transform.origin - collider.global_transform.origin
			sep_dir += _dist / _dist.length_squared()
	sep_dir.y = 0.0
	return sep_dir.normalized()

#attack entity
func atk(friends):
	if player in friends:
		if (player.global_transform.origin - global_transform.origin).length() < 2.0:
			if $AttackTimer.is_stopped():
				player.damage(20.0)
				$AttackTimer.start()

func die():
	if $CorpseTimer.is_stopped():
		$Particles.restart()
		$Particles2.restart()
		$MeshInstance.hide()
		$CorpseTimer.start()

func orient(dir, delta):
	var new_basis = Basis.IDENTITY
	new_basis.z = dir.normalized()
	new_basis.y = Vector3.UP
	new_basis.x = new_basis.y.cross(new_basis.z).normalized()
	var new_transform = global_transform
	new_transform.basis = new_basis
	global_transform = global_transform.interpolate_with(new_transform, 4.0 * delta)

func _on_CorpseTimer_timeout():
	var ammo_drop = load("res://ammo_pickup.tscn").instance()
	get_tree().current_scene.add_child(ammo_drop)
	ammo_drop.global_transform = global_transform
	queue_free()
