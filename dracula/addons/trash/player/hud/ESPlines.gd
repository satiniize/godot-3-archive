extends TextureRect

#
#onready var player = get_parent().get_parent()
#onready var target = player.get_node(player.target)
#
#func _ready():
#	pass
#
#func _draw():
#	var crosshair = get_parent().get_node("CenterContainer/Crosshair2")
#	var pos = get_parent().get_parent().get_node("CollisionShapeUpper/CamGroup/Camera").unproject_position(target.global_transform.origin)
#	if not get_parent().get_parent().get_node("CollisionShapeUpper/CamGroup/Camera").is_position_behind(target.global_transform.origin):
#		draw_line(crosshair.rect_position * Vector2(1.0, 2.0), pos, Color.red, 2)
#
#func _process(delta):
#	update()
