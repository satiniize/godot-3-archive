class_name Door

extends Interactable
onready var target_basis: Basis = transform.basis
onready var target_transform: Transform = transform
onready var prev_transform: Transform = transform
onready var closed_basis = transform.basis
var rot_speed = PI
var is_closed = true
var duration = 0.5
export(AudioStream) var door_open
export(AudioStream) var door_close

func _ready():
	prompt = "Press \"E\" to open."


func interact(player: Node):
	if not $IsBlocked.get_overlapping_bodies().size() > 0:
		prev_transform = transform
		var swing_dir = (player.global_transform.origin - global_transform.origin).dot(global_transform.basis.z)
		if is_closed:
			target_basis = closed_basis.rotated(Vector3.UP, PI/2 * sign(swing_dir))
			$AudioStreamPlayer3D.stream = door_open
		else:
			target_basis = closed_basis
			$AudioStreamPlayer3D.stream = door_close
		$AudioStreamPlayer3D.play()
		target_transform = transform
		target_transform.basis = target_basis
		is_closed = not is_closed
		$Duration.start(duration)
		#differentiate between player and enemy0
		if player is Player:
			get_tree().call_group("enemies", "add_sus_source", 10.0, global_transform.origin)


func _physics_process(delta):
	if not $Duration.is_stopped():
		transform = prev_transform.interpolate_with(target_transform, 1.0 - $Duration.time_left / $Duration.wait_time)
	if is_closed:
		prompt = "Press \"E\" to open."
	else:
		prompt = "Press \"E\" to close."



#	else:
#		var prev_time = $Duration.time_left
#		$Duration.start($Duration.wait_time - prev_time)
#	var angle = acos(prev_transform.basis.z.dot(target_transform.basis.z) / prev_transform.basis.z.length() / target_transform.basis.z.length())
#	var new_duration = angle / rot_speed
#	if $Duration.is_stopped():
