extends Node2D

var points: float

func _physics_process(delta):
	var points = 0.0
	for house in $Houses.get_children():
		points += (house.value + float(house.modulus) * 100.0) * house.max_points
	$Player.points = int(points)
