extends Control

var chapters = {
	0: "res://chapters/chapter1.tscn"
}

func _on_NewGame_pressed():
	get_tree().change_scene("res://gameworld/gameworld.tscn")


func _on_Debug_pressed():
	get_tree().change_scene("res://debug/debug.tscn")


func _on_Exit_pressed():
	get_tree().quit(OK)
