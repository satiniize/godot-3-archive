extends Spatial

export(ItemDef.AmmoType) var type
export(int) var amount


func _on_Area_body_entered(body):
	if body is Player:
		body.ammo[type] += amount
		queue_free()
