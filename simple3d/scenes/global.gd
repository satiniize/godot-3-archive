extends Node

var player_object_interact
var up
var down
var left
var right
var left_click
var right_click
var player_is_interacting
var player
var main_scene
var player_health: float = 100.0
var game_start: bool = false
var player_points: int = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	if Input.is_action_just_pressed("debug"):
		player_health -= 20.0
	player_health += delta
	player_health = clamp(player_health, 0.0, 100.0)
	up = Input.get_action_strength("ui_up")
	down = Input.get_action_strength("ui_down")
	left = Input.get_action_strength("ui_left")
	right = Input.get_action_strength("ui_right")
	left_click = Input.is_action_pressed("ui_left_click")
	right_click = Input.is_action_pressed("ui_right_click")
	if player_health <= 0.0:
		game_start = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		player.ui_switcher.switch_menu(player.ui_switcher.screens.END_SCREEN)
		get_tree().paused = true
		
func penalty(value: float):
	player_health -= value

func start_game():
	game_start = true
	main_scene.disable_menu_camera()
	player.ui_switcher.switch_menu(player.ui_switcher.screens.HUD)

func add_point(points: int):
	player_points += points
	player.hud.points.text = str(player_points)

func restart_game():
	player_points = 0
	game_start = false
	player_health = 100.0
	get_tree().reload_current_scene()
	get_tree().paused = false
