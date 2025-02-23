extends Entity


class_name Enemy


export(NodePath) var player_path
onready var player = get_node(player_path)
var aggresion


var speed = 1.5
var accel = 1.0
var damp = 0.9
var path2player = []
export(NodePath) var nav_path
onready var nav : Navigation = get_node(nav_path)
export(NodePath) var pot_path
onready var pot : Node = get_node(pot_path)
var pot_index = 0
var max_distance = 30
export(Array) var sounds
var sus_sources = {}

var prev_time : float = 0.0

enum Phase{
	STAY,
	WANDER,
	CHASE
}

var phase
#class SusSource:
#	var max_distance = 30
#	var weight
#	var pos
#	func calc_weight(current_pos):
#		var out = weight / (pos - current_pos).length() * max_distance
#		return int(round(out))

func _physics_process(delta):
	$PlayerVisibility.look_at(player.global_transform.origin + Vector3(0.0, 0.5, 0.0), Vector3.UP)
	decay_sus_source(delta)
	
	#start targeting
	var target_pos = get_sussiest_pos()
	if $PlayerVisibility.is_colliding():
		if $PlayerVisibility.get_collider() == player and not Debug.oblivius_enemy:
			target_pos = player.global_transform.origin
			if (player.global_transform.origin - global_transform.origin).length() < 1.0:
				jumpscare()
	if target_pos == null:
		var pot_children = pot.get_children()
		var delta_pos = pot_children[pot_index].global_transform.origin
		var threshold = 0.5
		if (delta_pos - global_transform.origin).length() < threshold:
			pot_index = randi() % pot_children.size()
		var node = pot_children[pot_index]
		target_pos = node.global_transform.origin
	var dir = get_path_dir(target_pos)
	
	velocity.y -= 9.8 * delta
	velocity *= pow(damp, delta)
	velocity.x = dir.x * accel
	velocity.z = dir.z * accel
	velocity = move_and_slide(velocity, Vector3.UP)
	orient(dir, delta)


func get_sussiest_pos():
	if sus_sources.size() > 0:
		var min_weight = sus_sources.keys().min()
		var loc = sus_sources[min_weight][1]
		return loc
	else:
		return null
		#actually path find

func orient(dir, delta):
	var new_basis = Basis.IDENTITY
	new_basis.z = dir
	new_basis.y = Vector3.UP
	new_basis.x = new_basis.y.cross(new_basis.z)
	var new_transform = global_transform
	new_transform.basis = new_basis
	global_transform = global_transform.interpolate_with(new_transform, 4.0 * delta)


func get_path_dir(pos : Vector3):
	var path = nav.get_simple_path(global_transform.origin, pos)
	var dir = Vector3.ZERO
	if path.size() > 0:
		dir = path[1] - path[0]
	dir = dir.normalized()
	return dir

func _on_Area_body_entered(body):
#	pass
	if body is Door:
		if body.is_closed:
			body.interact(self)

func open_door(body):
	if body is Door:
		if body.is_closed:
			body.interact(self)

func play_sound():
	$AudioStreamPlayer3D.stream = sounds[randi() % sounds.size()]
	$AudioStreamPlayer3D.play()


func _on_ScreamTimer_timeout():
#	play_sound()
	$ScreamTimer.start(rand_range(2.5, 5.5))


func calc_weight(weight : float, pos : Vector3):
	var out = weight / (pos - global_transform.origin).length() * max_distance
	return int(round(out))


func add_sus_source(weight : float, pos : Vector3):
	var relative_weight = calc_weight(weight, pos)
	sus_sources[relative_weight] = [weight, pos]
#	recalc_sus_source()
	play_sound()


#func recalc_sus_source():
#	var tmp_sus_source = {}
#	for key in sus_sources:
#		var relative_weight = calc_weight(sus_sources[key][0], sus_sources[key][1])
#		tmp_sus_source[relative_weight] = [sus_sources[key][0], sus_sources[key][1]]
#	sus_sources = tmp_sus_source
#	Debug.debug_log = [str(sus_sources)]


func decay_sus_source(delta : float):
	var tmp_sus_source = {}
	for key in sus_sources:
		var weight = sus_sources[key][0] - delta
		var pos = sus_sources[key][1]
		var delta_pos = (pos - global_transform.origin).length()
		var threshold = 1.0
		if delta_pos > threshold:
			if weight > 0.0:
				var relative_weight = calc_weight(weight, pos)
				tmp_sus_source[relative_weight] = [weight, pos]
	sus_sources = tmp_sus_source
	Debug.debug_log = [str(sus_sources)]

func jumpscare():
	play_sound()
#	get_tree().quit()


	#get sussiest spot ie doors, mp3players, game sounds
#	if sus_sources.size() > 0:
#	var min_weight = sus_sources.keys().min()
#	var loc = sus_sources[min_weight][1]
	#actually path find
	
#	else:
#		velocity.x = 0.0
#		velocity.z = 0.0

