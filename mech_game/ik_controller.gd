extends Node2D

var bicep_length = 13.0
var forearm_length = 17.0
var thigh_length = 24.0
var calf_length = 28.0
var joint_length = 7.0

export var body_path: NodePath
onready var body = get_node(body_path)
export var bicep_L_path: NodePath
onready var bicep_L: Bone2D = get_node(bicep_L_path)
export var hand_L_path: NodePath
onready var hand_L = get_node(hand_L_path)
export var bicep_R_path: NodePath
onready var bicep_R: Bone2D = get_node(bicep_R_path)
export var hand_R_path: NodePath
onready var hand_R = get_node(hand_R_path)
export var thigh_L_path: NodePath
onready var thigh_L: Bone2D = get_node(thigh_L_path)
export var thigh_R_path: NodePath
onready var thigh_R: Bone2D = get_node(thigh_R_path)
export var body_target_path: NodePath
onready var body_target = get_node(body_target_path)
export var arm_target_L_path: NodePath
onready var arm_target_L = get_node(arm_target_L_path)
export var arm_target_R_path: NodePath
onready var arm_target_R = get_node(arm_target_R_path)
export var leg_target_L_path: NodePath
onready var leg_target_L = get_node(leg_target_L_path)
export var leg_target_R_path: NodePath
onready var leg_target_R = get_node(leg_target_R_path)
onready var targets = get_parent().get_node("targets")
export var walk_threshold: float
enum move_mode{ARM, LEG}
var time = 0.0

func _physics_process(_delta):
	move_limb(bicep_L, bicep_length, forearm_length, arm_target_L, 1.0)
	move_limb(bicep_R, bicep_length, forearm_length, arm_target_R, 1.0)
	move_limb(thigh_L, thigh_length, calf_length, leg_target_L, -1.0, targets.foot_L_normal)
	move_limb(thigh_R, thigh_length, calf_length, leg_target_R, -1.0, targets.foot_R_normal)
	body.global_position = body_target.global_position
	hand_R.global_rotation = 0.0
#	print(rad2deg(acos((-0.6 + 1.565) / 1.5)))
	print(rad2deg(0.196349540849))
#	print((getIKangle(sqrt(1.5*1.5 - 0.5*0.5), 1.5, 0.5)))
#	print(sin(getIKangle(0.75, 2.1, 1.5)) * 0.75)
#	print(tan(deg2rad(15)) * 4)
#	print(rad2deg(0.244978663127))
func getIKangle(side1: float, side2: float, hypotenuse: float):
	return acos( (pow(side1, 2.0) + pow(side2, 2.0) - pow(hypotenuse, 2.0)) /
							(side1 * side2 * 2.0) )

func move_limb(root_bone, upper_bone_length, lower_bone_length, target, bend: float, foot_normal: Vector2 = Vector2.ZERO):
	##BICEP
	root_bone.rotation = (bend * getIKangle(upper_bone_length + joint_length / 2.0, 
						min(root_bone.global_position.distance_to(target.global_position), upper_bone_length + lower_bone_length + joint_length), lower_bone_length + joint_length / 2.0) + 
							target.global_position.angle_to_point(root_bone.global_position)) - PI/2.0
	##ELBOW AND FOREARM
	var lower_rot = (bend * getIKangle(upper_bone_length + joint_length / 2.0, 
						lower_bone_length + joint_length / 2.0, min(root_bone.global_position.distance_to(target.global_position), upper_bone_length + lower_bone_length + joint_length)) + PI * bend)
	root_bone.get_child(0).rotation = (PI + lower_rot) / 2.0 + PI/2.0
	root_bone.get_child(0).get_child(0).rotation = (PI + lower_rot) / 2.0 + PI/2.0
	if foot_normal.length() > 0.0:
		root_bone.get_child(0).get_child(0).get_child(0).global_rotation = Vector2.ZERO.angle_to_point(foot_normal) + deg2rad(35) + PI*3.0/2.0
