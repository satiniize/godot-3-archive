extends TileMap

var crate
var goblin
var slime
var Selected

signal renew(number)

func _on_Visibility_screen_exited() -> void:
	var number = self.global_position.y / 12 + self.global_position.x / 60
	emit_signal("renew", number)
	queue_free()
	
func setup() -> void:
	randomize()
	var color = Color(randi() % 101 / 100.0, randi() % 101 / 100.0, randi() % 101 / 100.0, 1)
	self.modulate = color
	var tile = (randi() % 4) + 6
	if true:
		for posy in range(0, 5):
			for posx in range(0, 5):
				if self.get_cell(posx, posy) == 10:
					pass
				else:
					self.set_cell(posx, posy, tile)
					
				# only the bricks are buggy need to fix
	match randi() % 3:
		0:
			crate = preload("res://Scenes/Crate.tscn")
			Selected = crate.instance()
		1:
			goblin = preload("res://Scenes/Goblin.tscn")
			Selected = goblin.instance()
		2:
			slime = preload("res://Scenes/Slime.tscn")
			Selected = slime.instance()

	get_parent().get_parent().get_node("Enemies").call_deferred("add_child", Selected)
	match randi() % 2:
		0:
			Selected.global_position = $SpawnLocations/Spawn1.global_position
		1:
			Selected.global_position = $SpawnLocations/Spawn2.global_position
			

