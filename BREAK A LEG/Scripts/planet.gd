tool
extends KinematicBody2D

export var color: Color
export var gravity: float
var normal: Vector2
var isplanet = true
var constant = 220000

func _ready():
	var shape = CircleShape2D.new()
	shape.radius = gravity / 4
	$CollisionShape2D.shape = shape
	
func linear(arg: Vector2):
	var linear = pow(pow(arg.x, 2) + pow(arg.y, 2), 0.5)
	return linear
	
func _draw():
	draw_circle(Vector2.ZERO, $CollisionShape2D.shape.radius, color)

func _physics_process(delta):
	for node in get_parent().get_children():
		if node is KinematicBody2D and node.get("velocity") != null and not Engine.editor_hint:
			normal = (global_position - node.global_position).normalized()
			node.velocity += gravity * normal * delta * constant/ pow(linear(global_position - node.global_position),2) 
			node.gravity += gravity * normal * delta * constant/ pow(linear(global_position - node.global_position),2)

