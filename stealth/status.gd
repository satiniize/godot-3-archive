extends Node2D

var is_on_fire: bool
var fire_damage: float = 0.2
onready var parent = get_parent()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if is_on_fire:
		parent.health -= fire_damage

func start_fire():
	is_on_fire = true
	$fire/fire_particle.emitting = true
	$fire/fire_timer.start()
	
func _on_fire_timer_timeout():
	is_on_fire = false
	$fire/fire_particle.emitting = false
