extends CanvasLayer

export(NodePath) var player_path
onready var player = get_node(player_path)

func _process(delta):
	$HBoxContainer/CenterContainer/HealthBar.value = player.health / player.base_health * 100.0
	$HBoxContainer/CenterContainer/StaminaBar.value = player.stamina / player.base_stamina * 100.0

	$VBoxContainer2/FPS.text = "FPS : " + str(Performance.get_monitor(Performance.TIME_FPS))
	$CenterContainer/VBoxContainer/PromptPickup.text = player.current_prompt
#	$CenterContainer/TextureProgress.value += 1
#	$CenterContainer/TextureProgress.value = wrapi($CenterContainer/TextureProgress.value, 0, 100)
#	$Inventory.text = str(player.inventory)
	if player.inventory.size() > 0:
		$HBoxContainer/Item.text = player.inventory[player.current_item].name
#	$VBoxContainer/Item.text = ""
#	for item in player.inventory:
#		$VBoxContainer/Item.text += item.name + ", " 
#	use_fullbright($WindowDialog/VBoxContainer/FullBright.pressed)
	if Input.is_action_just_pressed("debug"):
		$WindowDialog.popup()
	if $WindowDialog.visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$WindowDialog/HBoxContainer/RichTextLabel.text = str(Debug.debug_log)
	debug()

func debug():
	Debug.full_bright = $WindowDialog/HBoxContainer/VBoxContainer/FullBright.pressed
	Debug.oblivius_enemy = $WindowDialog/HBoxContainer/VBoxContainer/ObliviusEnemy.pressed

#func d_print(string : String):
#	$WindowDialog/HBoxContainer/RichTextLabel.add_text(string + "\n")
