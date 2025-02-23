class_name DroppedItem


extends Interactable


export(String) var item_id
var item_manager = preload("res://items/item_manager.tres")

func _ready():
	prompt = "Press \"E\" to pick up " + item_manager.items[item_id].name + "."


func interact(player: Node):
#	return item_manager.get_item_resource(item_id)
#	prompt_pickup = true
#	if input_dict[input.ITEM_USE]:
	player.inventory.append(item_manager.get_item_resource(item_id))
	queue_free()
