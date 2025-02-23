extends Node2D
onready var armor_array = [$body/head, $body, $body/bicep_L, $body/bicep_L/elbow_L/forearm_L, $body/bicep_R, $body/bicep_R/elbow_R/forearm_R, $body/thigh_L, $body/thigh_L/knee_L/calf_L, $body/thigh_R, $body/thigh_R/knee_R/calf_R]

export(Array, Color) var color
export(Color) var eye_color
export var child_material: Material
enum armor{PLASTIC, ALUMINIUM, CARBON_FIBER}
onready var body = [$body]
onready var head = [$body/head]
onready var upper_arm_L = [$body/bicep_L, $body/bicep_L/elbow_L]
var upper_arm_L_armor = armor.PLASTIC
onready var lower_arm_L = [$body/bicep_L/elbow_L/forearm_L, $body/bicep_L/elbow_L/forearm_L/hand_L]
var lower_arm_L_armor = armor.PLASTIC
#onready var upper_arm_R = [$body/bicep_R, $body/bicep_L/elbow_R]
#onready var lower_arm_R = [$body/bicep_L/elbow_L/forearm_R, $body/bicep_L/elbow_L/forearm_L/hand_R]
#onready var upper_leg_L = [$body/thigh_L, $body/thigh_L/knee_L]
#onready var lower_leg_L = [$body/thigh_L/knee_L/calf_L, $body/thigh_L/knee_L/calf_L/foot_L]
#onready var upper_leg_R = [$body/thigh_R, $body/thigh_L/knee_R]
#onready var lower_leg_R = [$body/thigh_L/knee_L/calf_R, $body/thigh_L/knee_L/calf_L/foot_R]
#var armor_array: Array = [PLASTIC, PLASTIC, PLASTIC, PLASTIC, PLASTIC, PLASTIC, PLASTIC]
#func _ready():
#	randomize()
#	update_color()
#func random_color():
#	return Color(rand_range(0.5, 1.0), rand_range(0.5, 1.0), rand_range(0.5, 1.0), 1.0)
#
#func update_color():
#	var count = 0
#	for i in color:
#		armor_array[count].material.set_shader_param("color", random_color())
#		if count == 0:
#			armor_array[count].material.set_shader_param("eye_color", eye_color)
#		count += 1

#func setup_material():
#	for i in 
