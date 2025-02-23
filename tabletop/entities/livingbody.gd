extends KinematicBody2D

class_name LivingBody

var health = 10

func damage(amount : int):
	health -= amount
