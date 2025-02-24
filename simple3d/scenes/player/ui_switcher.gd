extends Node

export(PackedScene) var main_menu
export(PackedScene) var hud
export(PackedScene) var end_screen
export(PackedScene) var pause_menu

enum screens{MAIN_MENU, HUD, END_SCREEN, PAUSE_MENU}
export(screens) var current

var current_screen

func _ready():
	switch_menu(current)
	
func switch_menu(screen: int):
	if current_screen is Object:
		current_screen.queue_free()
	match screen:
		screens.MAIN_MENU:
			current_screen = main_menu.instance()
		screens.HUD:
			current_screen = hud.instance()
		screens.END_SCREEN:
			current_screen = end_screen.instance()
		screens.PAUSE_MENU:
			current_screen = pause_menu.instance()
	add_child(current_screen)
