extends Spatial

var player_is_visible: bool

func _physics_process(delta):
	$PeekLeft.rotation = -get_parent().rotation
	$PeekRight.rotation = -get_parent().rotation
	var offset = Vector3(0.0, 0.85, 0.0)
	$PeekLeft.cast_to = get_parent().player.get_global_transform().origin + offset - $PeekLeft.get_global_transform().origin
	$PeekRight.cast_to = get_parent().player.get_global_transform().origin + offset - $PeekRight.get_global_transform().origin
	player_is_visible = ($PeekLeft.get_collider() is Player) or ($PeekRight.get_collider() is Player)
