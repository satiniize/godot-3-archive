extends CanvasLayer

func _on_retry_pressed():
	Global.restart_game()

func _on_exit_pressed():
	get_tree().quit()
