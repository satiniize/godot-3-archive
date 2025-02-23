extends Spatial

func _ready():
	for i in $house.get_children():
		if i is MeshInstance:
			i.create_trimesh_collision()
