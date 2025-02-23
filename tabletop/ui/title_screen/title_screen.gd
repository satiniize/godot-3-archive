extends Control


func _on_Join_pressed():
	var err = Network.join_game()
	print(err)
	if err == OK:
		$Lobby.popup()


func _on_Quit_pressed():
	get_tree().quit()


func _on_Invite_pressed():
	OS.set_clipboard(str(Network.server_ip))
	$AlertInvite.popup()


func _on_Start_pressed():
	Network.rpc("load_game")


func _on_HostGame_pressed():
	Network.host_game()
	$Lobby.popup()


func _on_JoinGame_pressed():
	$JoinPopup.popup()


func _on_Settings_pressed():
	$Settings.popup()
