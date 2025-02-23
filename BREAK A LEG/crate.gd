extends "res://Scripts/entitybase.gd"

onready var player = get_parent().get_node("player")
onready var playerhitbox = get_parent().get_node("player/CollisionShape2D")
var slide = 400
var normal = Vector2.ZERO
var offset
var safepos: Vector2

#func _physics_process(delta):
#	$RayCast2D.rotation = self.get_angle_to(player.global_position)

#	if Input.is_action_pressed("click") and normal.y < 0:
#
#		if $RayCast2D.get_collider() == player:
#			velocity = player.velocity
#			safepos = global_position
#			$CollisionPolygon2D.disabled = true
#			global_position = player.global_position + (normal * 88)
#		elif $RayCast2D.get_collider() is TileMap:
#			global_position = safepos
#	else:
#		safepos = global_position
#		$CollisionPolygon2D.disabled = false
