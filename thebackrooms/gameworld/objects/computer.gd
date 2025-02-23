extends Interactable

var is_played = false
var base_fov = 40.0
var target_fov = base_fov
onready var target_transform: Transform = $CamPos.global_transform
var player_ref
var prev_transform: Transform
var prev_player_transform : Transform
#var sit_transform : Transform
#var stand_transform : Transform

func _ready():
	prompt = "Press [E] to play the computer"
#	sit_transform = $PlayerParent.global_transform


func interact(player: Node):
	#toggle
	is_played = not is_played
	#stop player
	player.velocity = Vector3.ZERO
	prev_transform = player.global_transform
#	prev_transform.basis.z *= -1.0
#	prev_transform.basis.x *= -1.0
	if is_played:
		target_transform = $SitPos.global_transform
#		target_transform.basis.z *= -1.0
#		target_transform.basis.x *= -1.0
		
		$PlayerParent.global_transform = prev_transform
		player.transform = Transform.IDENTITY #reset
		player.look_rot.y = 0.0
		player.get_parent().remove_child(player)
		$PlayerParent.add_child(player)
#		player.transform.basis = Basis.IDENTITY #somehow not reset
		player.lock_move = true
	else:
		target_transform = $StandPos.global_transform
		player.look_rot.y = 0.0
		player.transform = Transform.IDENTITY #reset
	
	$Duration.start()


func _physics_process(delta):
	if not $Duration.is_stopped():
		print($PlayerParent.get_child(0).transform.basis.z)
		$PlayerParent.global_transform = prev_transform.interpolate_with(target_transform, 1.0 - $Duration.time_left / $Duration.wait_time)
	if is_played:
		prompt = "Press \"E\" to exit the computer"
	else:
		prompt = "Press \"E\" to play the computer"
	$Viewport/FakeGame.get_node("CanvasLayer/ColorRect").visible = not is_played


func _on_Duration_timeout():
	if not is_played:
		var player = $PlayerParent.get_child(0)
		player.lock_move = false
		$PlayerParent.remove_child(player)
		get_tree().current_scene.get_node("Entities").add_child(player)
		player.global_transform = target_transform

#		player.global_transform = prev_player_transform
#	prev_transform = $PlayerParent.global_transform
#	player_ref = player
#	prev_transform = transform

#		prev_player_transform = player.global_transform
#		target_transform = $CamPos.global_transform
#		target_transform.origin -= Vector3.UP * 1.7
#		player.global_transform = target_transform
#func _on_InteractTimer_timeout():
#	$Camera.current = is_played
#	player_ref.lock_view = is_played
#	player_ref.lock_move = is_played
#	var swing_dir = (player.global_transform.origin - global_transform.origin).dot(global_transform.basis.z)
#	if is_closed:
#		target_basis = closed_basis.rotated(Vector3.UP, PI/2 * sign(swing_dir))
#	else:
#		target_basis = closed_basis
#	target_transform = transform
#	target_transform.basis = target_basis
#	is_closed = not is_closed
#		target_fov = player.base_fov
#		$InteractTimer.start()
#		$Camera.global_transform = player.cam.global_transform
#		$Camera.current = is_played
#		$Camera.fov = player.base_fov
#		target_fov = base_fov
	
#	$Camera.global_transform = player.cam.global_transform
#		prev_transform = player.global_transform
#		player.global_transform = $PlayerParent.global_transform
#		$PlayerParent.transform.basis = Basis.IDENTITY
#		player.transform = Transform.IDENTITY#Vector3.ZERO#

