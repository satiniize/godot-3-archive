extends Interactable

func end_interact():
	Global.player.hand_state = Global.player.CLEAN

func _physics_process(_delta):
	if Global.player.hand_state == Global.player.DIRTY:
		needs_interaction = true
