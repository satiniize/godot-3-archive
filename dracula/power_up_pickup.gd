extends Spatial

export(ItemDef.PowerUp) var type
#export(int) var amount


func _on_Area_body_entered(body):
	if body is Player:
		body.power_up[type] = ItemDef.power_up_duration[type]
		queue_free()
