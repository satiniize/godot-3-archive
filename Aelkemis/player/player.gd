extends entity

var accel_dir: float
var buff_points: int = 10
enum weapons{BLADE, PISTOL, RIFLE, SCYTHE}
var current_weapon
var current_weapon_enum: int = weapons.BLADE
var spare_points: int
var accel: float = 500.0
var decel: float = 500.0
var agility_multiplier: float = 1.0
export(float) var armor_stat
onready var armor: float = armor_stat
export(float) var jump_force

func _ready():
	Global.player = self
	get_node("hud").setup(self)
	switch_weapon(weapons.BLADE)

func _physics_process(delta):
#	$Camera2D.global_position = global_position + get_global_mouse_position()
#	$Camera2D.global_position *= 0.5
	if Input.is_action_just_pressed("ui_cancel"):
		damage(1.5)
#	if Input.is_action_just_pressed("left_click"):
	accel_dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x += accel_dir * accel * delta
	if velocity.x != 0.0 and accel_dir == 0.0:
		if abs(velocity.x) - decel * delta < 0.0:
			velocity.x = 0.0
		else:
			velocity.x -= decel * velocity.normalized().x * delta
	velocity.x = clamp(velocity.x, -speed, speed)
	velocity.y += gravity * delta
	if Input.is_action_pressed("ui_accept"):
		if is_on_floor():
			if velocity.y > -jump_force:
				velocity.y = -jump_force
			$jump_timer.start()
		elif is_on_ceiling():
			$jump_timer.stop()
		elif !$jump_timer.is_stopped():
			if velocity.y > -jump_force:
				velocity.y = -jump_force
	else:
		if not is_on_floor():
			$jump_timer.stop()
	if Input.is_action_just_released("scroll_up"):
		switch_weapon(1)
	elif Input.is_action_just_released("scroll_down"):
		switch_weapon($weapons.get_child_count() - 1)
	if accel_dir != 0.0:
		$sprite.scale.x = accel_dir
	else:
		if (get_global_mouse_position() - global_position).x > 0.0:
			$sprite.scale.x = 1.0
		else:
			$sprite.scale.x = -1.0

func switch_weapon(offset: int):
	if current_weapon != null:
		current_weapon.set_active(false)
	current_weapon_enum += offset
	current_weapon_enum = current_weapon_enum % ($weapons.get_child_count())
	current_weapon = $weapons.get_child(current_weapon_enum)
	current_weapon.set_active(true)
	current_weapon.rotation = global_position.angle_to_point(get_global_mouse_position()) + PI
	current_weapon.apply_buff()
	update_stats()
	
func update_stats():
	for stats in $hud.stats:
		match stats.stat_of:
			stats.stat_modes.DAMAGE:
				stats.base_points = int(current_weapon.damage_base)
				stats.buff_points = int(current_weapon.damage_buff)
			stats.stat_modes.SPEED:
				stats.base_points = int(current_weapon.speed_base)
				stats.buff_points = int(current_weapon.speed_buff)
			stats.stat_modes.AGILITY:
				stats.base_points = int(current_weapon.agility_base)
				stats.buff_points = int(current_weapon.agility_buff)
		stats.refresh_stats()
		$hud.points.text = str(buff_points - vec3_sum(current_weapon.stat_buff))

func on_stat_changed(emitter, stat_mode, offset):
	if !vec3_sum(current_weapon.stat_buff) + offset > buff_points:
		match stat_mode:
			emitter.stat_modes.DAMAGE:
				current_weapon.damage_buff += offset
				current_weapon.damage_buff = clamp(current_weapon.damage_buff, 0.0, 10.0 - current_weapon.damage_base)
			emitter.stat_modes.SPEED:
				current_weapon.speed_buff += offset
				current_weapon.speed_buff = clamp(current_weapon.speed_buff, 0.0, 10.0 - current_weapon.speed_base)
			emitter.stat_modes.AGILITY:
				current_weapon.agility_buff += offset
				current_weapon.agility_buff = clamp(current_weapon.agility_buff, 0.0, 10.0 - current_weapon.agility_base)
		current_weapon.apply_buff()
		update_stats()

func vec3_sum(vec3: Vector3):
	return vec3.x + vec3.y + vec3.z

func set_agility_multiplier(multiplier: float, factor: float):
	agility_multiplier = multiplier
	speed = multiplier * factor
	accel = multiplier * factor * 5.0
	decel = multiplier * factor * 5.0
	jump_force = multiplier * factor
	
func damage(value: float):
	$armor_timer.start()
	var armor_over = armor - value
	armor = armor_over
	$hud.set_armor(armor / armor_stat * 100.0)
	if armor_over < 0.0:
		health += armor_over
		armor = 0.0
		$hud.set_health(health / health_stat * 100.0)
		if health < 0.0:
			die()
#
#func damage(value: float):
#	$armor_timer.start()
#	if armor > 0.0:
#		armor -= value
#		$hud.set_armor(armor / armor_stat * 100.0)
#	else:
#		health -= value
#		$hud.set_health(health / health_stat * 100.0)
#		if health < 0.0:
#			die()

func _on_armor_timer_timeout():
	armor = armor_stat
	damage(0)
