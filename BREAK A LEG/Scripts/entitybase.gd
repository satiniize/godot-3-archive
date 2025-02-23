extends KinematicBody2D

const FLOOR_NORMAL: Vector2 = Vector2.UP
const TERMINAL_VELOCITY: float = 600.0
const WALK_DECEL = 10
export var bounce: bool = false
export var bounce_constant: float = 1.0
var mingrav: Vector2
var gravity: Vector2 = Vector2.ZERO
var velocity: Vector2
var velnormal: Vector2
var linear: float
var onceiling: bool
var onfloor: bool
var onwall: bool
var previousvel
var planets: Array

func linear(arg: Vector2):
	var linear = pow(pow(arg.x, 2) + pow(arg.y, 2), 0.5)
	return linear

func _physics_process(delta):
	velnormal = gravity.normalized()
	gravity = velnormal
	if bounce:
		if onwall:
			velocity.x = -1.0 * previousvel.x * bounce_constant
		if onfloor or onceiling:
			velocity.y = -1.0 * previousvel.y * bounce_constant
		
	previousvel = velocity
	velocity = move_and_slide(velocity, -velnormal)
	onceiling = is_on_ceiling()
	onfloor = is_on_floor()
	onwall = is_on_wall()
	
	linear = linear(velocity)
	if velnormal.y < 0:
		rotation = asin(velnormal.x) - PI
	else:
		rotation = acos(velnormal.x) - PI / 2
		
	velocity = velocity.normalized() * min(linear(velocity), TERMINAL_VELOCITY)
