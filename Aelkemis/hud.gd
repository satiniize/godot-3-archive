extends CanvasLayer

onready var stats = get_node("vbox").get_children()
onready var points = get_node("TextureRect/points")
#var health_value
#var armor_value

func setup(node):
	for i in stats:
		i.connect("buff_button_pressed", node, "on_stat_changed")

#func _physics_process(delta):
#	$TextureProgress.value -= 1.0
#	if $TextureProgress.value <= 0.0:
#		$TextureProgress2.value -= 1.0
#		if $TextureProgress2.value <= 0.0:
#			$TextureProgress.value = 100.0
#			$TextureProgress2.value = 100.0

func set_health(value: float):
	$health_bar.value = value

func set_armor(value: float):
	$armor_bar.value = value
