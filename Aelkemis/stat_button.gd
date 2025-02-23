extends HBoxContainer

onready var bar = get_node("bar")
var base_points: int
var buff_points: int
enum stat_modes{DAMAGE, SPEED, AGILITY}
export(stat_modes) var stat_of
signal buff_button_pressed(emitter, stat_mode, offset)

func _ready():
	match stat_of:
		stat_modes.DAMAGE:
			$TextureRect/Label.text = "DMG"
		stat_modes.SPEED:
			$TextureRect/Label.text = "SPD"
		stat_modes.AGILITY:
			$TextureRect/Label.text = "AGT"

func refresh_stats():
	var count: int = 0
	for child in bar.get_children():
		if count < base_points:
			child.show()
			child.modulate = Color(0.5, 0.5, 0.5, 1.0)
		elif count < buff_points + base_points:
			child.show()
			child.modulate = Color(1.0, 1.0, 1.0, 1.0)
		else:
			child.hide()
		count += 1

func _on_add_pressed():
	emit_signal("buff_button_pressed", self, stat_of, 1)

func _on_subtract_pressed():
	emit_signal("buff_button_pressed", self, stat_of, -1)
