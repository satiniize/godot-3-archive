extends CanvasLayer

func _on_start_pressed():
	Global.start_game()

func _on_exit_pressed():
	get_tree().quit()

