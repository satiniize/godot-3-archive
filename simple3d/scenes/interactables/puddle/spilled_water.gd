extends Interactable

func _ready():
	needs_interaction = true

func end_interact():
	queue_free()
