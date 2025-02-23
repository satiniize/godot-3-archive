extends Item


var omnilight : OmniLight


func _init():
	name = "Lantern"
	omnilight = OmniLight.new()
	omnilight.omni_range = 6.0
	omnilight.light_energy = 2.0
	omnilight.light_color = Color(1.0, 0.75, 0.0, 1.0)
	omnilight.shadow_enabled = true
	omnilight.global_transform.origin = Vector3(1.0, -1.0, -1.0) * 0.25

func active(item_node: Node):
	if not is_active:
		item_node.add_child(omnilight)
	is_active = true

func remove():
	is_active = false
	omnilight.get_parent().remove_child(omnilight)
