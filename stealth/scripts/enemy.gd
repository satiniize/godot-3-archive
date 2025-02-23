extends KinematicBody2D

export var player_path: NodePath
export var nav_path: NodePath
export var alerted: Texture
export var curious: Texture
export var alerted_mask: Texture
export var curious_mask: Texture
var last_seen: Vector2
var player: KinematicBody2D
var cast: RayCast2D
var nav: Navigation2D
var alert: Sprite
var detection: float
var detection_rate: float = 128.0
var speed: float = 32
var velocity: Vector2 = Vector2.ZERO
var alert_mask: Light2D
var state
var killable = true
enum {IDLE, SEARCH, PATROL}



func _ready(): #Assigning Nodes
	last_seen = global_position
	state = IDLE
	player = get_node(player_path)
	cast = get_node("cast")
	nav = get_node(nav_path)
	alert = get_node("alert")
	alert_mask = get_node("alert/alert_mask")



func _physics_process(delta):
	velocity = move_and_slide(velocity)
	cast.rotation = self.get_angle_to(player.global_position)
	for i in $sight.get_overlapping_bodies():
		match i.get_class():
			KinematicBody2D:
				if i == self:
					pass
#					cast.rotation = self.get_angle_to(i.global_position)
			_:
				pass
	var cast_colliding = cast.get_collider()
	if cast_colliding in $sight.get_overlapping_bodies():
		match cast_colliding.get("type"):##NEEDS IMPROVEMENT
			"player":
				detection += detection_rate * delta
			"crate":
				if cast_colliding.grabbed:
					detection += detection_rate * delta
				else:
					detection -= detection_rate * delta
			_:
				detection -= detection_rate * delta
	else:
		detection -= detection_rate * delta
	
	detection = max(detection, 0.0)
	detection = min(detection, 150.0)
	$sight.rotation = self.get_angle_to(velocity.normalized() + global_position)
	match state:
		IDLE:
			handle_alert()
			path_find(last_seen)
		SEARCH:
			path_find(last_seen)
#			if velocity.y < 0:
#				$sight.rotation = asin(velocity.normalized().x) - PI / 2
#			else:
#				$sight.rotation = acos(velocity.normalized().x)
			if cast.get_collider() == player:
				detection += detection_rate * delta
				last_seen = player.global_position
			if detection < 100.0:
				state = IDLE
		PATROL:
			pass



func handle_alert() -> void:#Detection
	if detection < 100.0 and detection > 0:
		alert.texture = curious
		alert_mask.texture = curious_mask
		alert.show()
	elif int(detection) > 100:
		last_seen = player.global_position
		alert.texture = alerted
		alert_mask.texture = alerted_mask
		alert.show()
		state = SEARCH
	else:
		alert.hide()



func path_find(argument: Vector2):
	var points
	if player.global_position != null:
		points = nav.get_simple_path(self.global_position, argument, false)
		if points.size() > 1:
			var distance = points[1] - self.global_position
			var direction = distance.normalized()
			if points.size() > 2:
				velocity = speed * direction
			else:
				velocity = Vector2.ZERO



func linear(argument: Vector2):
	return (pow(pow(argument.x, 2.0) + pow(argument.y, 2.0), 0.5))
