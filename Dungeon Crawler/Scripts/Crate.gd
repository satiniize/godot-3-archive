extends KinematicBody2D

onready var hitbox = get_node("Hitbox")
onready var player = get_parent().get_parent().get_node("Player")
onready var sprite = get_node("Sprite")
var holding = 1
var cursorposition
var color

func _ready() -> void:
	randomize()
	color = Color(randi() % 101 / 100.0, randi() % 101 / 100.0, randi() % 101 / 100.0, 1)
	sprite.modulate = color
	player.connect("hit", self, "_on_Player_hit")
	
func _on_Player_hit(body: Area2D, _value, button) -> void:
	if body == hitbox and button == 1:
		holding *= -1

func _physics_process(_delta: float) -> void:
	if holding == -1:
		self.global_position = get_global_mouse_position()
		self.add_collision_exception_with(player)
	else:
		self.remove_collision_exception_with(player)

func _on_Visibility_screen_exited():
	queue_free()
