extends Spatial

#onready var camera1 = $PortalView1/Camera1
#onready var camera2 = $PortalView2/Camera2
#onready var cameraplayer = $Player.cam
#onready var portalmesh1 = $PortalMesh1
#onready var portalmesh2 = $PortalMesh2
#var has_entered_portal1 = false
#var has_entered_portal2 = false

#func _process(delta):
#	var cam_relative: Transform = cameraplayer.global_transform
#	cam_relative.origin = cam_relative.origin - portalmesh1.global_transform.origin
#	cam_relative.scaled(Vector3(0.0, -1.0, 0.0))
#	camera2.global_transform = cam_relative
#	camera2.global_transform.
#origin += portalmesh2.global_transform.origin
#
#	var cam_relative2: Transform = cameraplayer.global_transform
#	cam_relative2.origin = cam_relative2.origin - portalmesh2.global_transform.origin
#	cam_relative2.scaled(Vector3(0.0, -1.0, 0.0))
#	camera1.global_transform = cam_relative2
#	camera1.global_transform.origin += portalmesh1.global_transform.origin
	
#func _physics_process(delta):

#	var player_portal1_offset = cameraplayer.global_transform.origin - portalmesh1.global_transform.origin
#	if abs(player_portal1_offset.z) < 0.04 and abs(player_portal1_offset.x) < 0.5: #and abs(player_portal1_offset.y) < 1.0:
#		$Player.global_transform.origin = $PortalMesh2.global_transform.origin
#		$Player.global_transform.origin = $Player.global_transform.origin - Vector3(0.0, 1.0, 0.0) + player_portal1_offset * Vector3(1.0, 1.0, 0.0)
#		$Player.global_transform.origin -= (portalmesh2.global_transform.basis.z * portalmesh1.global_transform.basis.z.dot(player_portal1_offset)).normalized() * 0.04
#
#
#
#	var player_portal2_offset = cameraplayer.global_transform.origin - portalmesh2.global_transform.origin
#	if abs(player_portal2_offset.z) < 0.04 and abs(player_portal2_offset.x) < 0.5: #and abs(player_portal1_offset.y) < 1.0:
#		$Player.global_transform.origin = $PortalMesh1.global_transform.origin
#		$Player.global_transform.origin = $Player.global_transform.origin - Vector3(0.0, 1.0, 0.0) + player_portal2_offset * Vector3(1.0, 1.0, 0.0)
#		$Player.global_transform.origin -= (portalmesh1.global_transform.basis.z * portalmesh2.global_transform.basis.z.dot(player_portal2_offset)).normalized() * 0.04 
		
