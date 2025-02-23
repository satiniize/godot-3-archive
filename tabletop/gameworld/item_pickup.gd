extends Area2D

#var item_data = preload("res://player/weapons/item_data.tres")
#var id: String
#var texture: Texture
#var data
export(Resource) var item

func _ready():
	$Sprite.texture = item.texture
#func _ready():
#	data = item_data.items[id]
#	$Sprite.texture = data["image"]


func _on_DroppedItem_body_entered(body):
#	if body is Player:
		# v surely there must be a better solution
		# this would allow item stacking, to avoid use list
		# renungkan dulu gan
#		body.inventory.append(id)
		var can_pickup = body.give_item(item)
		if can_pickup:
			queue_free()
#		if body.inventory.has(id):
#			body.inventory[id] += 1
#		else:
#			body.inventory[id] = 1
#		queue_free()
