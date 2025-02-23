extends KinematicBody2D

var velocity : Vector2
var speed := 256.0
var gravity = 1024.0
var accel_dir: float
var buff_points: int = 10
enum weapons{BLADE, PISTOL, RIFLE, SCYTHE}
var current_weapon
var current_weapon_enum: int = weapons.BLADE
var spare_points: int
var accel: float = 2048.0
var decel: float = 2048.0
var agility_multiplier: float = 1.0
export(float) var armor_stat
onready var armor: float = armor_stat
var jump_force: float = 128.0




func _physics_process(delta):
	accel_dir = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.x += accel_dir * accel * delta
	if velocity.x != 0.0 and accel_dir == 0.0:
		if abs(velocity.x) - decel * delta < 0.0:
			velocity.x = 0.0
		else:
			velocity.x -= decel * velocity.normalized().x * delta
	velocity.x = clamp(velocity.x, -speed, speed)
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if Input.is_action_pressed("ui_accept"):
		if is_on_floor():
			if velocity.y > -jump_force:
				velocity.y = -jump_force
			$JumpTimer.start()
		elif is_on_ceiling():
			$JumpTimer.stop()
		elif !$JumpTimer.is_stopped():
			if velocity.y > -jump_force:
				velocity.y = -jump_force
	else:
		if not is_on_floor():
			$JumpTimer.stop()
	if accel_dir != 0.0:
		$Sprite.scale.x = accel_dir
	else:
		if (get_global_mouse_position() - global_position).x > 0.0:
			$Sprite.scale.x = 1.0
		else:
			$Sprite.scale.x = -1.0
