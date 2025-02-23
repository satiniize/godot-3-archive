extends Node

onready var enemy_node = get_tree().current_scene.get_node("Enemies")
enum EnemyType{
	MINION,
	ORC,
	BIGBOY
}

var enemies = {
	EnemyType.MINION : preload("res://enemies/minion/minion.tscn"),
	EnemyType.ORC : preload("res://enemies/orc/orc.tscn"),
	EnemyType.BIGBOY : preload("res://enemies/bigboy/BigBoy.tscn")
}

var hordes = []


#func _ready():



func randomstr(length: int):
	var characters = "abcdefghijklmnopqrstuvwxyz" #ABCDEFGHIJKLMNOPQRSTUVWXYZ
	var index = range(length)


func summon_enemy(type: int, amount: int=1):
	for i in range(amount):
		var enemy_instance = enemies[type].instance()
		enemy_node.add_child(enemy_instance)
		enemy_instance.add_to_group("null")


func handle_enemy_groups():
	for horde in hordes:
		pass


func finished_setup():
	var enemy_instance = load("res://enemies/minion/minion.tscn").instance()
	enemy_instance.global_position = Vector2(64.0, -64.0)
	enemy_instance.player = get_tree().current_scene.get_node("Players").get_child(0)
	enemy_instance.flowfield = get_tree().current_scene.get_node("FlowField")
	get_tree().current_scene.get_node("Enemies").add_child(enemy_instance)
#Formations
