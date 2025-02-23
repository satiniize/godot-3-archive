extends "res://Scripts/entitybase.gd"

const WALK_ACCEL = 20
const WALK_MAX = 500
const JUMP = -500
const WALL_JUMP = 400
onready var bomb = preload("res://Scenes/bomb.tscn")
onready var cast1 = get_node("RayCast2D")
onready var cast2 = get_node("RayCast2D2")
var kinetic_energy = Vector2.ZERO
var noclip: int = 1 
var distance = 96
var mouse_normal
var normal
var cursordistance
var shoot = 500
var goals = 0
var v_slowdown = 0.5
var h_slowdown = 250
export var v_cap: bool
export var h_cap: bool
 
func _physics_process(delta):
	normal = Vector2(cos(rotation), sin(rotation))
	$RayCast2D2.rotation = self.get_angle_to(get_global_mouse_position())
	velocity += (Input.get_action_strength("right") - Input.get_action_strength("left")) * WALK_ACCEL * (1.0 if onfloor else 0.1) * normal
	if h_cap:
		velocity = min(linear(velocity), h_slowdown) * velocity.normalized()
	handle_gun($gun)
#
#	normal = Vector2(cos(rotation), sin(rotation))
#	$RayCast2D2.rotation = self.get_angle_to(get_global_mouse_position())
#	linear_speed += (Input.get_action_strength("right") - Input.get_action_strength("left")) * WALK_ACCEL
#	velocity = min(linear_speed, h_slowdown if h_cap else linear) * normal
#	$gun.rotation = self.get_angle_to(get_global_mouse_position())
#

	if Input.is_action_pressed("jump"):
		if onfloor:
			velocity += JUMP * velnormal * (v_slowdown if v_cap else 1.0)
#		elif cast1.get_collider() is TileMap and !onfloor:
#			velocity.y = JUMP / 2
#			velocity.x = WALL_JUMP * sin(cast1.rotation)
	
	cursordistance = get_global_mouse_position() - global_position
	mouse_normal = cursordistance.normalized()
	if Input.is_action_pressed("right_mouse") and cast2.is_colliding():
		if  cast2.get_collider().get("velocity") != null:
			cast2.get_collider().velocity = velocity
			cast2.get_collider().global_position = global_position + distance * mouse_normal 
	elif Input.is_action_just_pressed("left_mouse") and cast2.get_collider() == null:
		var shootspeed = cursordistance * 1.0
		var newbomb = bomb.instance()
		get_parent().add_child(newbomb)
		newbomb.position = global_position + distance * mouse_normal
		newbomb.velocity = velocity
		newbomb.velocity += shootspeed

func handle_gun(sprite: Sprite) -> void:
	var rotate = self.get_angle_to(get_global_mouse_position())
	sprite.rotation = rotate
	if rotate < -(PI / 2) or rotate > (PI / 2):
		sprite.flip_v = true
	else:
		sprite.flip_v = false

#pi / 2 - & +
