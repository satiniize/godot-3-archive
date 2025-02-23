class_name Weapon

extends Item

var raycast: RayCast
var damage = 20.0

func _init():
	name = "Sickle"
	raycast = RayCast.new()
	raycast.cast_to = Vector3(0.0, 0.0, -2.0)
	raycast.enabled = true

func active(item_node: Node):
	item_node.add_child(raycast)

func remove():
	raycast.get_parent().remove_child(raycast)

func primary():
	if raycast.is_colliding():
		var collider = raycast.get_collider()
#		if collider is Hantu:
		collider.damage(damage)
