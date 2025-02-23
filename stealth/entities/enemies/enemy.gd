extends KinematicBody2D

onready var status = get_node("status")
var last_seen: Vector2
var player: KinematicBody2D
var cast: RayCast2D
var alert: Sprite
var speed: float = 32
var velocity: Vector2 = Vector2.ZERO
var target_velocity: Vector2 = Vector2.ZERO
var alert_mask: Light2D
var state
var killable = true
var type = "enemy"
var variant_parent
var cast_colliding
enum states{STAND, TOWARDS, RETREAT, STRAFE}
var health: float = 10
onready var global = get_node("/root/Global")

var fire_timer: Timer

func _ready():
#	fire_timer = Timer.new()
#	get_parent().add_child()
	player = get_node("/root/Global").player
	randomize()
	state = states.STAND
	last_seen = global_position
	cast = get_node("cast")

func _physics_process(delta):
	velocity = move_and_slide(velocity)
	cast.rotation = self.get_angle_to(player.global_position)
	cast_colliding = cast.get_collider()
	if cast_colliding == player:
		$attack_cooldown.wait_time = rand_range(1.0, 2.5)
	if health < 0:
		variant_parent.enemy_count -= 1
		queue_free()
	match state:
		states.STAND:
			pass
		states.RETREAT:
			velocity = (player.global_position - global_position).normalized() * -speed
		states.STRAFE:
			velocity = (player.global_position - global_position).normalized().rotated((1) * 2 + 1.0 * PI/2.0) * speed
		states.TOWARDS:
			velocity = (player.global_position - global_position).normalized() * speed
	velocity = min(linear(velocity), speed) * velocity.normalized()

func die(value: float):
	health -= value
#	velocity += (global_position - player.global_position) * 16

func linear(argument: Vector2):
	return (pow(pow(argument.x, 2.0) + pow(argument.y, 2.0), 0.5))

func _on_state_change_timeout():
	state = randi() % 4

func return_strafe(vector: Vector2):
	var output = Vector2(vector.y, vector.x)
	return output

func _on_attack_cooldown_timeout():
	if cast_colliding == player:
		player.damage()
	$attack_cooldown.wait_time = rand_range(1.0, 2.5)

func path_find(argument: Vector2):
	var points
	if player.global_position != null:
		points = global.room_nav.get_simple_path(self.global_position, argument, false)
		if points.size() > 0:
			var distance = points[1] - self.global_position
			var direction = distance.normalized()
			velocity += speed * direction
