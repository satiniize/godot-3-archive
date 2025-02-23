extends TextureRect


var seperator = 2


func _process(delta):
	update()


func _draw():
	for slot in get_parent().get_parent().player.inventory:
		var item = get_parent().get_parent().player.inventory[slot]
		if item:
			var tex = item.texture
			var pos = tex.get_size() + Vector2(seperator, 0.0)
			pos *= Vector2(float(slot), 0.0)
			pos.x += seperator / 2
			pos.y += seperator / 2
			draw_texture(tex, pos)
