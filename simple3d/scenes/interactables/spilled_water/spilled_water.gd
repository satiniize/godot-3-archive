extends Interactable

func _ready():
	needs_interaction = true

func end_interact():
	if randi() % 4 == 0:
		Global.player.hand_state = Global.player.DIRTY
	queue_free()
