extends Node2D

func _physics_process(delta):
	get_node("particle").emitting = Input.is_action_pressed("left_click")
	if Input.is_action_pressed("left_click"):
		get_node("particle").emitting
		for i in $hitreg.get_overlapping_bodies():
			i.get_node("status").start_fire()
