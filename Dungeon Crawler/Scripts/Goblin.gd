extends KinematicBody2D

signal damage(value)
var health = 20
onready var cast = get_node("CollDetect/Cast")
onready var hitbox = get_node("CollDetect/Hitbox")
onready var polygons = get_node("Polygons")
onready var hittime = get_node("Misc/Hit")
onready var player = get_parent().get_parent().get_node("Player")
onready var playerhitbox = get_parent().get_parent().get_node("Player/CollDetect/HitBox")
onready var rooms = get_parent().get_parent().get_node("Rooms")
var currentcolor
var max_speed = 40
var velocity = Vector2.ZERO
var walk_accel_x = 10.0
var walk_accel_y = 8.0
var playerpos
var offset = Vector2(6, 6)
var points

func _ready() -> void:
	currentcolor = Color(randi() % 101 / 100.0, randi() % 101 / 100.0, randi() % 101 / 100.0, 1)
	polygons.modulate = currentcolor
	player.connect("hit", self, "_on_Player_hit")
	var shape = CircleShape2D.new()
	shape.radius = cast.cast_to.x
	cast.add_exception(get_node("CollDetect/Hitbox"))
	
func _physics_process(_delta: float) -> void:
	cast.rotation = self.get_angle_to(player.global_position)
	
	if cast.get_collider() == playerhitbox:
		playerpos = cast.get_collision_point() - Vector2(4, 7)
		var distance = self.global_position.distance_to(playerpos)
		if abs(distance) <= 24:
			emit_signal("damage", 1)
		
	##### MOVEMENT #####
	velocity = move_and_slide(velocity)
	
	if playerpos != null:
		points = rooms.get_simple_path( self.global_position, playerpos, false)
		if points.size() > 1:
			var distance = points[1] - self.global_position
			var direction = distance.normalized()
			if points.size() > 2:
				velocity = max_speed * direction
			else:
				velocity = Vector2.ZERO

	##### VELOCITY CAPPING #####
	if velocity.x > 0:
		velocity.x = min(velocity.x, max_speed)
	else:
		velocity.x = max(velocity.x, -max_speed)
		
	if velocity.y > 0:
		velocity.y = min(velocity.y, max_speed)
	else:
		velocity.y = max(velocity.y, -max_speed)


##### INFLICTED DAMAGE #####
func _on_Player_hit(body: Area2D, value, _button) -> void:
	if body == hitbox:
		health -= value
		if health <= 0:
			player.points += randi() % 3 + 3
			queue_free()
		polygons.modulate = Color(1, 0, 0, 1)
		hittime.start()

func _on_Hit_timeout() -> void:
	polygons.modulate = currentcolor

func _on_Visibility_screen_exited():
	queue_free()
