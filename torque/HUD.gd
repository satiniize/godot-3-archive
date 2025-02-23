extends CanvasLayer

export(NodePath) var car_path
onready var car = get_node(car_path)

func _process(delta):
	$Speed.text = "SPEED : " + str(car.linear_velocity.length() * 3.6) + " KM/H"
	
