extends Interactable

class_name Toilet

onready var anim = get_node("plunger_anim")
var used_by
enum{BROKEN, FIXED}
var state = FIXED

func _physics_process(_delta):
	$Particles.emitting = needs_interaction
	if interacting and needs_interaction:
		anim.play("plunging")
	else:
		anim.play("idle")

func getBroken():
	state = BROKEN
	needs_interaction = true

func end_interact():
	state = FIXED
	if randi() % 2 == 0:
		Global.player.hand_state = Global.player.DIRTY


