extends CanvasLayer

#func _ready():
#	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_continue_pressed():
	Global.player.ui_switcher.switch_menu(Global.player.ui_switcher.screens.HUD)
	get_tree().paused = false

func _on_exit_pressed():
	get_tree().quit()

#func _physics_process(delta):
#	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
