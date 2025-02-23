extends Node

export var mesh: Mesh
#
#func _physics_process(delta):
#	for i in get_children():
#		i.queue_free()
#	var path = get_parent().path_to_target
#	if len(path) > 1:
#		for i in path:
#			var mesh_instance = MeshInstance.new()
#			mesh_instance.mesh = mesh
#			add_child(mesh_instance)
#			mesh_instance.global_transform.origin = i
