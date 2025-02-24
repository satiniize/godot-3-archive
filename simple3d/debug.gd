extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var toilet = get_node("toilet")
onready var table = get_node("table_for_two")
export var people: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	print(toilet.used_by, toilet.state)
	print(table.chair2.needs_interaction)
	if Input.is_action_just_pressed("ui_accept"):
		summon_customer()
	if Input.is_action_just_pressed("debug"):
		toilet_time()
	if Input.is_action_just_pressed("ui_right_click"):
		toilet.getBroken()

func summon_customer():
	var selected_chair = table.get("chair" + str(randi() % 2 + 1))
	if selected_chair.stored_people == null:
		selected_chair.stored_people = people.instance()
		selected_chair.add_child(selected_chair.stored_people)

func toilet_time():
	var selected_chair = table.get("chair" + str(randi() % 2 + 1))
	if selected_chair.stored_people is KinematicBody:
		selected_chair.stored_people.goToToilet(toilet)
