tool
extends Skeleton2D

export var chain_length: int
export var bone_length1 = 16.0
export var bone_length2 = 16.0
export var mirrored: bool
var target: Vector2 = get_global_mouse_position()

#func _draw():
#	draw_line(Vector2.ZERO, target, Color(1.0, 0.0, 0.0, 1.0), 1.5)
#	draw_line($Bone2D/Bone2D2.global_position, target / 2.0, Color.green, 1.5)
#
func _physics_process(delta):
	bone_length1 = $Bone2D.default_length
	bone_length2 = $Bone2D/Bone2D2.default_length
	update()
	target = $Position2D.global_position
	var bone1rot = getIKangle(bone_length1, target.length(), bone_length2)
#	var bone1rot = ((pow(bone_length1, 2.0) - pow(bone_length2, 2.0) + pow(clamp(target.length(), -min(bone_length1, bone_length2) + 0.1, bone_length1 + bone_length2), 2.0)) /
#										(bone_length1 * clamp(target.length(), -min(bone_length1, bone_length2) + 0.1, bone_length1 + bone_length2) * 2.0) )
	var bone2rot = ((pow(bone_length1, 2.0) - pow(clamp(target.length(), -min(bone_length1, bone_length2) + 0.1, bone_length1 + bone_length2), 2.0) + pow(bone_length2, 2.0)) /
										(bone_length1 * bone_length2 * 2.0) )
#	var calc_rot = ((pow(clamp(target.length(), -32.0, 32.0), 2.0)) /
#										(bone_length1 * clamp(target.length(), -32.0, 32.0) * 2.0) )
	$Bone2D.rotation = (-bone1rot + target.angle_to_point(Vector2.ZERO))
	$Bone2D/Bone2D2.rotation = (-acos(bone2rot) + PI)

func remainder(value1: float, value2: float):
	var output = value1
	while(output - value2 > value2):
		output -= value2
	return(output)

func getIKangle(side1: float, side2: float, hypotenuse: float):
	return acos( (pow(side1, 2.0) + pow(side2, 2.0) - pow(hypotenuse, 2.0)) /
							(side1 * side2 * 2.0) )
