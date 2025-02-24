extends Interactable

class_name Chair

export var steak_meal: PackedScene
var meal
var stored_people

func end_interact():
	if stored_people != null:
		needs_interaction = false
		stored_people.RefreshState(stored_people.EATING)
		if Global.player.hand_state == Global.player.DIRTY:
			print("ew disgustang")
			Global.penalty(rand_range(5.0, 10.0))

func summon_meal():
	meal = steak_meal.instance()
	add_child(meal)
	meal.global_transform.origin = $pos.global_transform.origin

func remove_meal():
	if meal != null:
		meal.queue_free()

func is_interacting(_delta):
	if stored_people != null and Global.player.stored_meals > 0:
		needs_interaction = false
		Global.player.stored_meals -= 1
		end_interact()

#func _on_chair_body_entered(body):
#	if body is ThrownMeal and needs_interaction:
#		end_interact()## remove held meal needs to be seperate
#		body.queue_free()
