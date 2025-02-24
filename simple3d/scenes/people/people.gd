extends KinematicBody

class_name People

var velocity: Vector3
var target_pos: Vector3
var speed: float
var distance_to_target: Vector3
enum{YOWHADDUP, SIT, EATING, GOINTODATOILET, BACKFROMDATOILET, LEAVE}
var state
var chair_pos
var has_ordered: bool = false
var used_toilet
onready var chair_parent = get_parent()
export var anger_alert_threshold: float
var received_points: int

func _ready():
	$ngambek_timer.start(randi() % 5 + 11)
	chair_pos = get_parent().get_global_transform().origin
	RefreshState(YOWHADDUP)
	chair_parent.needs_interaction = true
	$anim.play("entry")

func RefreshState(new_state):
	state = new_state
	match state:
		YOWHADDUP:
			goToPos(chair_pos)
			RefreshState(SIT)
		SIT:
			pass ##toilet needs interactions offs
		EATING:
			received_points = int($ngambek_timer.time_left / $ngambek_timer.wait_time * 1000)
			Global.add_point(received_points)
			$ngambek_timer.stop()
			$eat_timer.start(randi() % 5 + 11)
			chair_parent.summon_meal()
			$alert.hide()
			has_ordered = true
		GOINTODATOILET:
			chair_parent.needs_interaction = false
		BACKFROMDATOILET:
			RefreshState(SIT)

func goToPos(value: Vector3):
	global_transform.origin = value

func goToToilet(toilet):## needs rework
	if toilet.used_by == null and toilet.state == toilet.FIXED:
		$ngambek_timer.set_paused(true)
		RefreshState(GOINTODATOILET)
		used_toilet = toilet
		$boker_timer.start(rand_range(4.0, 5.0))
		global_transform = toilet.get_global_transform()
		toilet.used_by = self
		Global.penalty(rand_range(0, Global.main_scene.spills.get_child_count()))## floors wet ig
		print("toilet time")
	else:
		Global.penalty(rand_range(5.0, 15.0))## ew theres no working toilets

func leave(penalty: float):
	chair_parent.remove_meal()
	Global.penalty(penalty)
	print("left")
	queue_free()

func _on_boker_timer_timeout():
	if randi() % 2 == 0:
		used_toilet.getBroken()
	$ngambek_timer.set_paused(false)
	used_toilet.used_by = null
	global_transform = chair_parent.get_global_transform()
	if has_ordered:
		chair_parent.needs_interaction = false
	else:
		chair_parent.needs_interaction = true
	RefreshState(BACKFROMDATOILET)
	
func _on_eat_timer_timeout():
	leave(0.0)

func _on_ngambek_timer_timeout():
	leave(rand_range(10.0, 20.0))

func _physics_process(_delta):
	if $ngambek_timer.time_left <= anger_alert_threshold and not has_ordered:
		$anger.show()
	else:
		$anger.hide()
