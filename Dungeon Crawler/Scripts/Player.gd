extends KinematicBody2D

signal hit(Area2D, value, button)
var walk_accel_x = 20.0
var walk_accel_y = 16.0
var max_speed = 80.0
var velocity = Vector2.ZERO
var damage = 5
var shootable = true
var points = 0
onready var headgroup = get_node("Polygons/HeadGroup")
onready var cast = get_node("CollDetect/Cast")
onready var animations = get_node("Misc/AnimationPlayer")
onready var cooldown = get_node("Misc/Cooldown")

func _ready() -> void:
	cast.add_exception($CollDetect/HitBox)

func _physics_process(_delta: float) -> void:
	##### CURSOR TRACKING #####
	var cursor = get_global_mouse_position() - Vector2(4.5, 8.5)
	cast.rotation = self.get_angle_to(cursor)
	
	##### MOVEMENT #####
	velocity = move_and_slide(velocity)
	velocity.y += (Input.get_action_strength("down") - Input.get_action_strength("up")) * walk_accel_y
	velocity.x += (Input.get_action_strength("right") - Input.get_action_strength("left")) * walk_accel_x
	
	##### SPEED CAPPING #####
	if velocity.x > 0:
		velocity.x = min(velocity.x, max_speed)

#		headgroup.position = Vector2.ZERO
	else:
		velocity.x = max(velocity.x, -max_speed)

#		headgroup.position = Vector2(9, 0)
	
	if Input.is_action_pressed("debug4"):
		self.scale = Vector2(1, -1)
	if Input.is_action_pressed("debug3"):
		self.scale = Vector2(-1, -1)
		
	if velocity.y > 0:
		velocity.y = min(velocity.y, max_speed)
	else:
		velocity.y = max(velocity.y, -max_speed)

	##### SLOWDOWN ####
	if not Input.is_action_pressed("down") and not Input.is_action_pressed("up"):
		velocity.y *= 0.8
	if not Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
		velocity.x *= 0.9
		
	##### ANIMATIONS #####  ##probably be replaced
	if shootable and not Input.is_action_pressed("right") and not Input.is_action_pressed("left") and not Input.is_action_pressed("down") and not Input.is_action_pressed("up"):
		animations.play("Idle")
	elif shootable:
		animations.play("Walk")
	if cast.is_colliding() and shootable:
		var button
		if Input.is_action_just_pressed("left_click"):
			button = 0
			emit_signal("hit", cast.get_collider(), damage, button)
			animations.play("Attack")
			cooldown.start()
			shootable = false
		elif Input.is_action_just_pressed("right_click"):
			button = 1
			emit_signal("hit", cast.get_collider(), damage, button)
			animations.play("Attack")
			cooldown.start()
			shootable = false
		
	##### DEBUGGING #####
	if Input.is_action_pressed("debug1"):
		$Collision.disabled = true
	else:
		$Collision.disabled = false
		
func _on_Cooldown_timeout() -> void:
	shootable = true



func _on_Slime_collected(value):
	points += value
	print(points)
