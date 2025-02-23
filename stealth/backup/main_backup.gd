extends Node2D

export var variant1: PackedScene
export var variant2: PackedScene
export var variant3: PackedScene
export var variant4: PackedScene
export var variant5: PackedScene
onready var rooms = get_node("rooms")
enum{NORTH, WEST, EAST, SOUTH}
var overlapped = false

func _ready():
	randomize()
	generate(randi() % 5 + 5)

func generate(length: int) -> void:
	var prev_rotation
	var prev_room
	for i in range(0, length):
		var instance
		instance = self.get("variant" + str(randi() % 5 + 1)).instance()
		rooms.add_child(instance)
		var spot = randi() % 4
		if i == 0:
			instance.global_position = Vector2.ZERO
		else:
			instance.entrance = prev_room
			instance.allign(prev_room, instance, spot, prev_rotation)
#			print(spot, prev_rotation, instance.custom_rotation)
			instance.prev_room = prev_room
		
		prev_room = instance
		prev_rotation = instance.custom_rotation
		instance.prev_rotation = prev_rotation
		instance.prev_spot = spot
#	var prev_rotation
#	var prev_room
#	for i in range(0, length):
#		var instance
#		instance = self.get("variant" + str(randi() % 5 + 1)).instance()
#		rooms.add_child(instance)
#		var spot = randi() % 4
#		if i == 0:
#			instance.global_position = Vector2.ZERO
#		else:
#			instance.entrance = prev_room
#			instance.allign(prev_room, instance, spot, prev_rotation)
#			print(spot, prev_rotation, instance.custom_rotation)
#			instance.prev_room = prev_room
#
#		prev_room = instance
#		prev_rotation = instance.custom_rotation
#		instance.prev_rotation = prev_rotation
#		instance.prev_spot = spot
		
	overlapped = false

func _process(_delta):
	if overlapped or Input.is_action_just_pressed("debug"):
		clear_level()
		generate(randi() % 5 + 5)
	
func clear_level() -> void:
	for child in rooms.get_children():
		child.queue_free()

	
