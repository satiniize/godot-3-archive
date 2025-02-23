extends Item


var spotlight: SpotLight


func _init():
	name = "Flashlight"
	spotlight = SpotLight.new()
	spotlight.spot_range = 16.0
	spotlight.spot_angle = 30.0
	spotlight.light_energy = 2.0
	spotlight.light_color = Color(0.75, 0.75, 1.0, 1.0)
	spotlight.global_transform.origin = Vector3(1.0, -1.0, -1.0) * 0.25
#	spotlight.shadow_enabled = true

func active(item_node: Node):
	if not is_active:
		item_node.add_child(spotlight)
	is_active = true


func remove():
	is_active = false
	spotlight.get_parent().remove_child(spotlight)

func primary():
	spotlight.visible = not spotlight.visible
