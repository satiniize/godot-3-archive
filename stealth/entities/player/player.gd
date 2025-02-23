extends KinematicBody2D

export var cast_path: NodePath
var cast: RayCast2D
var velocity: Vector2 = Vector2.ZERO
var velocity_normal = Vector2.ZERO
var speed_cap = 64
var accel = 32.0
var cursor_normal: Vector2
var type = "player"
var camera_pos: Vector2
var selected_magic: int
var prev_pos: Vector2
var health = 20
enum{SPEED}

func _ready():
	damage()
	prev_pos = global_position
	cast = get_node(cast_path)
	
func _physics_process(delta):
	move($camera, velocity.normalized() * 32, 0.02)
	cast.rotation = self.get_angle_to(get_global_mouse_position())
	cursor_normal = (get_global_mouse_position() - global_position).normalized()
	velocity = move_and_slide(velocity)
	velocity_normal = Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
	velocity += velocity_normal * accel * delta * 60.0
	velocity = min(linear(velocity), speed_cap) * velocity.normalized()
#	$fire.get_node("particle").process_material.direction = Vector3(cursor_normal.x, cursor_normal.y, 0.0)
	$fire.rotation = cast.rotation
	
#	$fire.get_node("particle").process_material.initial_velocity = linear(velocity) + 60
	health = min(health, 20)
	
#	match selected_magic:
#		SPEED:
#			speed_cap = 128
	
	if !(Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")):
		velocity.x *= 0.8 * delta * 60.0
	if !(Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_up")):
		velocity.y *= 0.8 * delta * 60.0

#	if cast.is_colliding():
#		match cast.get_collider().get("type"):
#			"crate":
#				if Input.is_action_just_pressed("right_click"):
#					cast.get_collider().open()
#				if Input.is_action_pressed("left_click"):
#					move(cast.get_collider(), cursor_normal * 11 + global_position, 32)
#					cast.get_collider().grabbed = true
#				else:
#					cast.get_collider().grabbed = false
#			"enemy":
#				if Input.is_action_pressed("right_click"):
#					cast.get_collider().queue_free()

func linear(argument: Vector2):
	return (pow(pow(argument.x, 2.0) + pow(argument.y, 2.0), 0.5))

func move(object: Node2D, vec2_coord: Vector2, speed_: float):
	var distance = vec2_coord - object.global_position
	if object.get("velocity") == null:
		object.position += distance * speed_ + global_position / 50
	else:
		object.velocity = distance * speed_

func damage():
	health -= 1

func heal():
	health += 5
