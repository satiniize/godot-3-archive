extends Resource


var items = {
	"lantern" : preload("res://items/lantern.tres"),
	"flashlight" : preload("res://items/flashlight.tres"),
	"sickle" : preload("res://items/sickle.tres"),
	"mp3player" : preload("res://items/dap.tres")
}

func get_item_resource(item_id: String):
	var item_resource = (items[item_id] as Item).duplicate()
	return item_resource
