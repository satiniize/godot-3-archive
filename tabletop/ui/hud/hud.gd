extends CanvasLayer

var end_goal
var player

var mode: int
#var item_data = preload("res://player/weapons/item_data.tres")

var health = 0

func _ready():
	match mode:
		Network.Role.GAMEMASTER:
			$HBoxContainer.hide()
		Network.Role.WARRIOR:
			$PanelContainer.hide()
#	for i in range(6):
#		$PanelContainer2/ItemList.add_item("item" + str(i + 1), load("res://icon.png"))


func update_inventory():
	$ItemList.clear()
#	for item in player.inventory:
#		$PanelContainer2/ItemList.add_item(item_data.items[item]["name"], item_data.items[item]["image"])
#		$ItemList.add_item("", item_data.items[item]["image"])


func _process(delta):
	if end_goal != null and player != null:
		$CenterContainer.rect_rotation = rad2deg(atan2(end_goal.global_position.y - player.global_position.y, end_goal.global_position.x - player.global_position.x) + PI/2.0)
	$HBoxContainer/ProgressBar.value = health
#	player.current_weapon_id = $ItemList
#	if get_tree().get_frame() % 120:
#		for item in player.inventory:
#			$PanelContainer2/ItemList.add_item(item_data.items[item]["name"], item_data.items[item]["image"])


func _on_ItemList_item_selected(index):
	player.current_item_id = index

func transition():
	pass
