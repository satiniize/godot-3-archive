extends Interactable

var first_frame_exit = false

func _ready():
	needs_interaction = true
	
func end_interact():
	Global.player.stored_meals += 1
	needs_interaction = false

func _physics_process(_delta):
	if Input.is_action_just_released("ui_left_click") and Global.player.stored_meals < 5:
		needs_interaction = true
#	if !Input.is_action_just_released("ui_left_click"):
#		needs_interaction = false
#	else:
#
#		needs_interaction = true
#	if first_frame_exit:
#		if Input.is_action_pressed("ui_left_click"):
#			first_frame_exit = false
##		first_frame_exit = false
#	else:
#	if interacting:

#
#func _process(delta):
#	needs_interaction = Global.player.stored_meals < 5
	
