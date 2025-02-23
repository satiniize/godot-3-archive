extends Node2D

class_name weapon
var target
export(int) var damage_base = 0
export(int) var speed_base = 0
export(int) var agility_base = 0
onready var stat_base: Vector3 = Vector3(damage_base, speed_base, agility_base)
var damage_buff = 0
var speed_buff = 0
var agility_buff = 0
onready var stat_buff: Vector3 = Vector3(damage_buff, speed_buff, agility_buff)
onready var stat_total: Vector3 = stat_base
enum {PRIMARY, SECONDARY}
export(NodePath) var animation_node_path
onready var animation_node: AnimationPlayer = get_node(animation_node_path)
export(float) var speed_factor = 0.1
export(float) var agility_factor = 20.0
export(float) var damage_factor = 2.0
var damage: float
var damage_popup := preload("res://damage_popup.tscn")

func _ready():
	set_physics_process(false)
	visible = false
	
func attack(mode: int):
	if mode == PRIMARY:
		primary_attack()
	else:
		secondary_attack()

func primary_attack():
	pass

func secondary_attack():
	pass
	
func set_active(state: bool):
	set_physics_process(state)
	visible = state

func _physics_process(delta):
	rotation = global_position.angle_to_point(get_global_mouse_position()) + PI
	if (get_global_mouse_position() - global_position).x > 0.0:
		scale.y = 1.0
	else:
		scale.y = -1.0
	if not animation_node.is_playing():
		if Input.is_action_pressed("left_click"):
			attack(0)
		elif Input.is_action_pressed("right_click"):
			attack(1)
			
func apply_buff():
	recalculate_stats()
	animation_node.set_speed_scale(stat_total.y * speed_factor)
	Global.player.set_agility_multiplier(stat_total.z, agility_factor)
	damage = stat_total.x * damage_factor

func recalculate_stats():
	stat_buff = Vector3(damage_buff, speed_buff, agility_buff)
	stat_total = stat_base + stat_buff

func summon_popup(target: entity, damage: float):
	var popup = damage_popup.instance()
	get_tree().root.get_child(0).add_child(popup)
	popup.rect_global_position = target.global_position
	popup.text = str(damage)
	popup.tint(1.0 - damage / max(target.health, damage))
