extends Spatial

export(Resource) var weapon 

var bob = 0.0

func _ready():
	$AnimationPlayer.play("RESET")

func _on_Area_body_entered(body):
	$AnimationPlayer.play("pickup")
	body.add_weapon(weapon)

func _physics_process(delta):
	bob += delta
	$MeshInstance.transform.origin.y = 1.0 + sin(bob * 2.0) * 0.2
	$MeshInstance.transform = $MeshInstance.transform.rotated(Vector3.UP, delta)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "pickup":
		queue_free()
