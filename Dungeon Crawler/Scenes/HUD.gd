extends CanvasLayer

onready var score = get_node("Label")
onready var player = get_parent().get_node("Player")

func _process(delta):
	score.text = str(player.points)
