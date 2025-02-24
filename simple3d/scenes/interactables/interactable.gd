extends Area
class_name Interactable

var interacting: bool
var needs_interaction: bool = false
var percentage: float = 0.0
enum interact_modes{HORIZONTAL, VERTICAL, CLOCKWISE, COUNTER_CLOCKWISE, NONE}
export(interact_modes) var interact_type
var rotate_direction

func _physics_process(delta):
	if needs_interaction and Global.player_object_interact == self and Input.is_action_pressed("ui_left_click"):
		is_interacting(delta)
	else:
		not_interacting(delta)

func is_interacting(_delta):
	interacting = true
	if percentage >= 100.0:
		needs_interaction = false
		end_interact()

func not_interacting(_delta):
	interacting = false
	percentage = 0.0
	
func end_interact():
	pass

func _input(event):
	match interact_type:
		interact_modes.HORIZONTAL:
			if event is InputEventMouseMotion and interacting:
				percentage += abs(event.relative.x) * 0.1
		interact_modes.VERTICAL:
			if event is InputEventMouseMotion and interacting:
				percentage += abs(event.relative.y) * 0.02
		interact_modes.CLOCKWISE:
			if event is InputEventMouseMotion and interacting:
				percentage += max((event.relative).dot(rotate_direction), 0.0) * 0.02
			if event is InputEventMouse:
				rotate_direction = (event.position - (get_viewport().size / 2)).rotated(PI/2).normalized()
		interact_modes.COUNTER_CLOCKWISE:
			if event is InputEventMouseMotion and interacting:
					percentage += max((event.relative).dot(rotate_direction), 0.0) * 0.02
			if event is InputEventMouse:
				rotate_direction = (event.position - (get_viewport().size / 2)).rotated(-PI/2).normalized()
		interact_modes.NONE:
			pass
