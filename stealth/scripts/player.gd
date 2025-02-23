extends KinematicBody2D

export var cast_path: NodePath
var cast: RayCast2D
var velocity: Vector2 = Vector2.ZERO
var speed = 64
var cursor_normal: Vector2
var type = "player"
var camera_pos: Vector2
func _ready():
	cast = get_node(cast_path)

func _physics_process(delta):
	move($camera, velocity.normalized() * 32, 0.02)
	cast.rotation = self.get_angle_to(get_global_mouse_position())
	cursor_normal = (get_global_mouse_position() - global_position).normalized()
	velocity = move_and_slide(velocity)
	velocity.x = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")) * speed
	velocity.y = (Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")) * speed
	velocity = min(linear(velocity), speed) * velocity.normalized()
	if cast.is_colliding():
		if cast.get_collider().get("pushable"):
			if Input.is_action_pressed("left_click"):
				move(cast.get_collider(), cursor_normal * 11 + global_position, 32)
				cast.get_collider().grabbed = true
			else:
				cast.get_collider().grabbed = false
		if cast.get_collider().get("type") == "crate" and Input.is_action_just_pressed("right_click"):
			cast.get_collider().open()
		if cast.get_collider().get("killable") and Input.is_action_just_pressed("right_click"):
			cast.get_collider().queue_free()
	Polygon2D
func linear(argument: Vector2):
	return (pow(pow(argument.x, 2.0) + pow(argument.y, 2.0), 0.5))

func move(object: Node2D, vec2_coord: Vector2, speed_: float):
	var distance = vec2_coord - object.global_position
	if object.get("velocity") == null:
		object.position += distance * speed_ + global_position / 50
	else:
		object.velocity = distance * speed_
