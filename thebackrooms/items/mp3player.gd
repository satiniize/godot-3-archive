extends RigidBody


func _on_StartTimer_timeout():
	get_tree().call_group("enemies", "add_sus_source", 10.0, global_transform.origin)


func _on_PlayTimer_timeout():
	queue_free()
