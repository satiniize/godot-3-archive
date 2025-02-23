extends Node2D

onready var var1 = preload("res://Scenes/Variants/Variant1.tscn")
onready var var2 = preload("res://Scenes/Variants/Variant2.tscn")
onready var var3 = preload("res://Scenes/Variants/Variant3.tscn")
onready var var4 = preload("res://Scenes/Variants/Variant4.tscn")

func _on_Variant1_renew(number: int) -> void:
	var random_room = randi() % 4
	var new_room
	var pos
	
	match random_room:
		0:
			new_room = var1.instance()
		1:
			new_room = var2.instance()
		2:
			new_room = var3.instance()
		3:
			new_room = var4.instance()
			
	get_node("Rooms").call_deferred("add_child", new_room)
	new_room.connect("renew", self, "_on_Variant1_renew")
	match number:
		0:
			pos = $RoomLocations/Room1.global_position
		1:
			pos = $RoomLocations/Room2.global_position
		2:
			pos = $RoomLocations/Room3.global_position
		3:
			pos = $RoomLocations/Room4.global_position
		4:
			pos = $RoomLocations/Room5.global_position
		5:
			pos = $RoomLocations/Room6.global_position
		6:
			pos = $RoomLocations/Room7.global_position
		7:
			pos = $RoomLocations/Room8.global_position
		8:
			pos = $RoomLocations/Room9.global_position
		9:
			pos = $RoomLocations/Room10.global_position
		10:
			pos = $RoomLocations/Room11.global_position
		11:
			pos = $RoomLocations/Room12.global_position
		12:
			pos = $RoomLocations/Room13.global_position
		13:
			pos = $RoomLocations/Room14.global_position
		14:
			pos = $RoomLocations/Room15.global_position
		15:
			pos = $RoomLocations/Room16.global_position
		16:
			pos = $RoomLocations/Room17.global_position
		17:
			pos = $RoomLocations/Room18.global_position
		18:
			pos = $RoomLocations/Room19.global_position
		19:
			pos = $RoomLocations/Room20.global_position
		20:
			pos = $RoomLocations/Room21.global_position
		21:
			pos = $RoomLocations/Room22.global_position
		22:
			pos = $RoomLocations/Room23.global_position
		23:
			pos = $RoomLocations/Room24.global_position
		24:
			pos = $RoomLocations/Room25.global_position
	
	new_room.global_position = pos
	new_room.call_deferred("setup")
	
func _on_HUD_start_game() -> void:
	$Player.global_position = $Spawn.global_position
	randomize()
	for i in range(0, 25):
		var random_room = randi() % 4
		var new_room
		var pos
		
		match random_room:
			0:
				new_room = var1.instance()
			1:
				new_room = var2.instance()
			2:
				new_room = var3.instance()
			3:
				new_room = var4.instance()
				
		get_node("Rooms").add_child(new_room)
		new_room.connect("renew", self, "_on_Variant1_renew")
		match i:
			0:
				pos = $RoomLocations/Room1.global_position
			1:
				pos = $RoomLocations/Room2.global_position
			2:
				pos = $RoomLocations/Room3.global_position
			3:
				pos = $RoomLocations/Room4.global_position
			4:
				pos = $RoomLocations/Room5.global_position
			5:
				pos = $RoomLocations/Room6.global_position
			6:
				pos = $RoomLocations/Room7.global_position
			7:
				pos = $RoomLocations/Room8.global_position
			8:
				pos = $RoomLocations/Room9.global_position
			9:
				pos = $RoomLocations/Room10.global_position
			10:
				pos = $RoomLocations/Room11.global_position
			11:
				pos = $RoomLocations/Room12.global_position
			12:
				pos = $RoomLocations/Room13.global_position
			13:
				pos = $RoomLocations/Room14.global_position
			14:
				pos = $RoomLocations/Room15.global_position
			15:
				pos = $RoomLocations/Room16.global_position
			16:
				pos = $RoomLocations/Room17.global_position
			17:
				pos = $RoomLocations/Room18.global_position
			18:
				pos = $RoomLocations/Room19.global_position
			19:
				pos = $RoomLocations/Room20.global_position
			20:
				pos = $RoomLocations/Room21.global_position
			21:
				pos = $RoomLocations/Room22.global_position
			22:
				pos = $RoomLocations/Room23.global_position
			23:
				pos = $RoomLocations/Room24.global_position
			24:
				pos = $RoomLocations/Room25.global_position
				
		new_room.global_position = pos
		new_room.call_deferred("setup")
#		new_room.setup()
