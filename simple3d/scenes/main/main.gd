extends Spatial

onready var level = get_node("level")
onready var toilets = level.toilets
onready var tables = level.tables
onready var spill_area = level.spill_area
onready var spills = level.spills
export var max_spill: int = 5
export var people: PackedScene
export var spilled_water: PackedScene
var max_wait: float = 0.0
var wait_offset: float = 2.5
var deviation: float = 0.1

func _ready():
	Global.main_scene = self
	$event_timer.start()
	$difficulty_timer.start()

func _on_event_timer_timeout():
	if Global.game_start:
		match randi() % 3:
			0:## summoning people
				summon_customer()
			1:
				if randi() % 5 == 0:
					spil_some_water()
			2:## go to toilet
				toilet_time()
		var calc_wait = max_wait + wait_offset * $difficulty_timer.time_left / $difficulty_timer.wait_time
		print(calc_wait)
		$event_timer.start(rand_range(max_wait, calc_wait + deviation))

func toilet_time():
	var selected_chair = tables[randi() % len(tables)].get("chair" + str(randi() % 2 + 1))
	if selected_chair.stored_people is People:
		var selected_toilet = toilets[randi() % 3]
		selected_chair.stored_people.goToToilet(selected_toilet)

func summon_customer():
	var selected_chair = tables[randi() % len(tables)].get("chair" + str(randi() % 2 + 1))
	if selected_chair.stored_people == null:
		selected_chair.stored_people = people.instance()
		selected_chair.add_child(selected_chair.stored_people)

func spil_some_water():
	if spills.get_child_count() <= max_spill:
		var spil_area = spill_area[0].get_global_transform().origin - spill_area[1].get_global_transform().origin
		var spil_pos = Vector3(rand_range(0.0, spil_area.x), 0.0, rand_range(0.0, spil_area.z))
		var water_instance = spilled_water.instance()
		spills.add_child(water_instance)
		print("spilled")
		water_instance.global_transform.origin = spil_pos + spill_area[1].get_global_transform().origin

func _on_difficulty_timer_timeout():
	pass # Replace with function body.

func _process(_delta):
	if Input.is_action_pressed("ui_right_click"):
		clear_rigid()
		
func clear_rigid():
	for i in get_children():
		if i is RigidBody:
			i.linear_velocity = Vector3.ZERO

func disable_menu_camera():
	level.camera.current = false
#func _on_Button_pressed():
#	Global.game_start = true
#	level.camera.current = false
#	for i in $main_menu.get_children():
#		i.hide()

#func _physics_process(delta):
#	$Spatial2.global_transform.origin.z += delta * 10.0
#	if $Spatial2.global_transform.origin.z > 50.0:
#		$Spatial2.global_transform.origin.z -= 68.0
#	$Spatial2.global_transform.origin.z = int($Spatial2.global_transform.origin.z) % 100
