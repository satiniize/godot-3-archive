extends Control

var chosen_level: int = 0
export(Array) var levels

func _on_Start_pressed():
	$Popup.popup()

func _on_ClosePopupStart_pressed():
	$Popup.hide()

func _on_Exit_pressed():
	get_tree().quit()

func clear_level_select():
	for i in $Popup/MarginContainer/CenterContainer/VBoxContainer/HBoxContainer.get_children():
		i.pressed = false
	print(chosen_level)
func _on_Level0_button_down():
	chosen_level = 0
	clear_level_select()

func _on_Level1_button_down():
	chosen_level = 1
	clear_level_select()

func _on_Level2_button_down():
	chosen_level = 2
	clear_level_select()

func _on_Level3_button_down():
	chosen_level = 3
	clear_level_select()

func _on_Level4_button_down():
	chosen_level = 4
	clear_level_select()

func _on_LevelSelect_pressed():
	get_tree().change_scene_to(levels[chosen_level])
