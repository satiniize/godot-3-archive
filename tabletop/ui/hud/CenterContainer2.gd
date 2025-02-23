extends CenterContainer

var seperator = 2

func _process(delta):
	if get_parent().player:
		set_select_pos()

func set_select_pos():
	$InventorySelect.rect_position.x = float(get_parent().player.current_item_id) * 18.0 - 1.0

func _on_CenterContainer2_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		var id : int = floor(event.position.x / (16 + seperator))
		if event.button_index == BUTTON_LEFT:
			get_parent().player.current_item_id = id
		if event.button_index == BUTTON_RIGHT:
			get_parent().player.drop_item(id)
