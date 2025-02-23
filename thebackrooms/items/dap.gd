extends Item


var mp3player = preload("res://items/mp3player.tscn")
var world_node

func _init():
	name = "MP3 Player"

func active(item_node: Node):
#	if not is_active:
#		item_node.add_child(omnilight)
	is_active = true
	world_node = item_node

func remove():
	is_active = false
#	omnilight.get_parent().remove_child(omnilight)

func primary():
	var mp3player_instance = mp3player.instance()
	mp3player_instance.global_transform = world_node.global_transform
	mp3player_instance.apply_impulse(Vector3.ZERO, world_node.global_transform.basis.z * -0.5)
	world_node.get_tree().current_scene.get_node("Entities").add_child(mp3player_instance)
