extends Spatial

var nav_node_path: NodePath = "Navigation"
var player_path: NodePath = "Player"
var room_size = 32.0
export(Array) var rooms

func _ready():
	Global.navigation = $Navigation
	generate_map(5)

func generate_map(size: int):
	for z in range(size):
		for x in range(size):
			var y_dist = 0.0
			var position = Vector3((x - floor(size / 2.0)) * room_size, y_dist, (z - floor(size / 2.0)) * room_size)
			var random_room = rooms[randi() % len(rooms)]
			var room_instance = random_room.instance()
			$Navigation.add_child(room_instance)
			room_instance.global_transform.origin = position
			room_instance.setup()
