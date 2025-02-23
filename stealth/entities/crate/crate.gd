extends KinematicBody2D

export var opened: Texture
export var closed: Texture
var pushable = true
var grabbed = false
var velocity: Vector2
var type = "crate"
var state
enum{OPENED, CLOSED}

func _ready():
	state = CLOSED

func _physics_process(delta):
	velocity = move_and_slide(velocity)
	if not grabbed:
		velocity -= 4 * velocity.normalized()
	if int(linear(velocity)) < 3:
		velocity = Vector2.ZERO
	velocity = velocity.normalized() * max(0.0, linear(velocity))
	
func linear(argument: Vector2):
	return (pow(pow(argument.x, 2.0) + pow(argument.y, 2.0), 0.5))

func open():
	if state == CLOSED:
		$sprite.texture = opened
		$sprite.offset.y = -4
		state = OPENED
	else:
		$sprite.texture = closed
		$sprite.offset.y = 0
		state = CLOSED
