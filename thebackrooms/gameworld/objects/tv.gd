extends Interactable


func _ready():
	prompt = "Press \"E\" to turn on the TV"


func interact(player: Node):
	$AudioStreamPlayer3D.play()
