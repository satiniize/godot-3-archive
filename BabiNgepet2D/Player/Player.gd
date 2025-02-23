extends KinematicBody2D
var accel: float = 256.0
var accel_dir: Vector2
var velocity: Vector2
var friction: float = 1.0
var points: int = 0
var max_speed: float = 100.0
var health: int = 3

func _ready():
	Global.player = self

func _physics_process(delta):
	print(health)
	velocity = move_and_slide(velocity)
	accel_dir = Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
	velocity += accel_dir * accel * delta
	velocity -= velocity * friction * delta
	velocity = min(velocity.length(), max_speed) * velocity.normalized()
	rotation = get_look_dir(velocity.normalized())
	health = clamp(health, 0, 3)
	if health == 0:
		print("GAMEEND")
	$CanvasLayer/VBoxContainer/Points.text = str(points)
	var red_modulate = 1.0 - ($Invincibility.time_left / $Invincibility.wait_time)
	$Sprite.modulate = Color(1.0, red_modulate, red_modulate, 1.0)
	var count = 0
	for i in $CanvasLayer/VBoxContainer/HBoxContainer.get_children():
		i.visible = count < health
		count += 1

func get_look_dir(look_dir: Vector2):
	return Vector2.ZERO.angle_to_point(look_dir.normalized())

func damage():
	if $Invincibility.is_stopped():
		health -= 1
		$Invincibility.start()

func _on_PauseButton_pressed():
	$CanvasLayer/Popup.popup()
	get_tree().paused = true

func _on_ResumeButton_pressed():
	$CanvasLayer/Popup.hide()
	get_tree().paused = false

func _on_MainMenuButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://UI/MainMenu.tscn")
