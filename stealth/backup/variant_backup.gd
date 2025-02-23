extends TileMap

onready var north = get_node("north")
onready var south = get_node("south")
onready var west = get_node("west")
onready var east = get_node("east")
var entrance = self
var init = false
var custom_rotation = randi() % 4
var rotation_normal: Array = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
enum{NORTH, SOUTH, WEST, EAST}
onready var source: Array = [east, south, west, north]
onready var target: Array = [west, north, east, south]

var prev_room
var prev_spot
var prev_rotation

func _process(delta):
	if init:
		allign(prev_room, self, prev_spot, prev_rotation)
	
func _on_overlap(_area):
#	custom_rotation = randi() % 4
#	allign(prev_room, self, prev_spot, prev_rotation)
	get_parent().get_parent().overlapped = true
	
func allign(target1: TileMap, target2: TileMap, spot: int, new_rotation: int) -> void:
	var compass2 = target2.source[(spot + new_rotation) % 4]
	var compass1 = target1.target[(spot + custom_rotation) % 4]
	target2.global_position = (compass1.global_position) - (return_rotate(compass2.position, custom_rotation))
	target2.rotation = PI/2 * custom_rotation

func return_rotate(value: Vector2, in_rotation: int):
	var pos_neg = [1, -1, -1, 1]
	var vec2_swap = [value.x, value.y]
	return Vector2(vec2_swap[in_rotation % 2] * pos_neg[in_rotation], vec2_swap[(in_rotation + 1) % 2] * pos_neg[in_rotation - 1])

