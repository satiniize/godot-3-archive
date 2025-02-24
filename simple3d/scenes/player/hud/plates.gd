tool
extends Control

export var meals: int

func _physics_process(_delta):
	var count: int = 1
	for i in get_children():
		i.visible = not count > meals
		var shade
		if meals > 0:
			shade = float(count) / float(meals)
			i.modulate = Color(shade, shade, shade, 1.0)
		else:
			i.modulate = Color("black")
		count += 1
