extends Enemy

var prev_dir : Vector3
var cur_dir : Vector3 = Vector3.FORWARD
var rot_speed = PI / 8.0
onready var pivot : Node = get_node("Pivot")


func _physics_process(delta):
	var player_dir = player.global_transform.origin - global_transform.origin
	player_dir = player_dir.normalized()
	
	var perpendicular = cur_dir.cross(player_dir).normalized()
	var angle = cur_dir.angle_to(player_dir)
	
	cur_dir = cur_dir.rotated(perpendicular, min(angle, rot_speed * delta))
	
	var new_self_basis = Basis.IDENTITY
	var new_look_basis = Basis.IDENTITY
	
	var flat_z : Vector3 = cur_dir * Vector3(1.0, 0.0, 1.0)
	flat_z = flat_z.normalized()
	new_self_basis.z = flat_z
	new_self_basis.x = new_self_basis.y.cross(flat_z).normalized()

	var look_basis_z : Vector3
	look_basis_z.x = 0.0
	look_basis_z.y = cur_dir.dot(Vector3.UP)
	look_basis_z.z = sqrt(1.0 - look_basis_z.y*look_basis_z.y)
	
	new_look_basis.z = look_basis_z.normalized()
	new_look_basis.y = look_basis_z.cross(new_look_basis.x)
	new_look_basis.y = new_look_basis.y.normalized()
	
	var self_transform = self.transform
	self_transform.basis = new_self_basis
	var look_transform = pivot.transform
	look_transform.basis = new_look_basis

	self.transform = self_transform
	pivot.transform = look_transform
