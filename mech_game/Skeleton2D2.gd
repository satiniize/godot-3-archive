tool
extends Skeleton2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	$Bone2D.rotation += 0.1
	$Bone2D/Bone2D2.rotation += 0.1
	$Bone2D/Bone2D2/Bone2D3.rotation += 0.1
	$Bone2D/Bone2D2/Bone2D3/Bone2D4.rotation += 0.1
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
