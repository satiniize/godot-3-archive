extends Spatial

export(NodePath) var path_to_player

#FOR SOME FUCKING REASON THE ROOM NEEDS TO BE SHIFTED BY 8 UNITS
#ON THE Z AXIS NEED MORE TESTING

#FUCK GODOT YOU CANT MOVE NAVIGATION NODES OR ITLL FUCK IT UP NEED TO RESET IT
export(Array) var doors
var dormant = true

func _ready():
	for door in doors:
		get_node(door).toggle_door(true)

func setup():
	var level_transform = $Navigation/Level.global_transform
	global_transform.origin = Vector3.ZERO
	$Navigation/Level.global_transform = level_transform

func _on_PlayerTrigger_body_entered(body):
	if $Navigation/Level/Enemies.get_child_count() > 0:
		for enemy in $Navigation/Level/Enemies.get_children():
			enemy.dormant = false
		for door in doors:
			get_node(door).toggle_door(false)

func _physics_process(delta):
	if $Navigation/Level/Enemies.get_child_count() == 0:
		for door in doors:
			get_node(door).toggle_door(true)
