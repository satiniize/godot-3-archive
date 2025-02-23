extends Entity

class_name Player

#node shit
export(NodePath) var sun_path
onready var sun : DirectionalLight = get_node(sun_path)

onready var cam : Camera = get_node("UpperCollision/Camera")
onready var look_dir : Vector3 = cam.transform.basis.z

#movement
var gravity : float = 24.0
var move_dir : Vector3 = Vector3.ZERO
var ground_accel : float = 128.0
var air_accel : float = 128.0
var ground_max_speed : float = 16.0
var air_max_speed : float = 1.5
var friction : float = 0.001
var jump_height = 2.0
var just_crouched = false
onready var jump_impulse = sqrt(2.0 * gravity * jump_height)

#weapon
var inventory = []
var current_weapon = 0
var prev_weapon = 0
var recoil: Vector3
#x would be vertical recoil
#y would be horizontal sway
#z would be screen rotation
var current_screen_shake_amplitude : float = 0.0
var bob: float
var viewmodel_target_transform : Transform
var weapon_cooldown_timer = 0.0
var shotgun_ammo : int = 36
var grenade_ammo : int = 36
#enum AmmoType{
#	SHELL,
#	GRENADE,
#}
var ammo : Dictionary = {
	ItemDef.AmmoType.SHELL : 36,
	ItemDef.AmmoType.GRENADE : 8,
	ItemDef.AmmoType.LIGHT : 60,
}#dictionary smictionary idc could probably be an array
var power_up : Dictionary = {
	ItemDef.PowerUp.SUN_SCREEN : 0.0
}
#vampire shit
#var is_bat_form : bool = false
#var bat_form_max_charge = 100.0#?? make better names dumbass
#var bat_form_charge = bat_form_max_charge#?? make better names dumbass
#var bat_form_depletion_rate = 40.0
#var bat_form_regeneration_rate = 20.0
#var bat_form_lock = false
var vamp_max_charge = 100.0
var vamp_charge = vamp_max_charge
var vamp_charge_rate = 20.0

var dodge = 1.0

enum input{
	MOVE_DIR,
	MOVE_JUMP,
	MOVE_RUN,
	MOVE_CROUCH,
	WEAPON_PRIMARY,
	WEAPON_SECONDARY,
	WEAPON_RELOAD,
	LOOK_DIR
}

func _ready():
	viewmodel_target_transform = $UpperCollision/Camera/Armature002.transform
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
func _input(event):
	if event is InputEventMouseMotion:
		var perpendicular : Vector3
		perpendicular = Vector3.UP.cross(look_dir).normalized()

		if look_dir.rotated(perpendicular, px_to_rad(-event.relative.y)).dot(look_dir * Vector3(1.0, 0.0, 1.0)) > 0:
			look_dir = look_dir.rotated(perpendicular, px_to_rad(-event.relative.y))
		look_dir = look_dir.rotated(Vector3.UP, px_to_rad(-event.relative.x))

func px_to_rad(pixels : float):
	var sens = 20.8
	var dpi = 1000
	return pixels / (dpi / 2.54) / sens * PI * 2.0
	
func _physics_process(delta):
	move_dir = (
		-cam.global_transform.basis.z * (Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")) +
		cam.global_transform.basis.x * (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	).normalized()
	look()
	move(delta)
	vamp(delta)
	weapon(delta)
	power_up(delta)
	if inventory.size() > 0: #and not is_bat_form:
		viewmodel_target_transform.origin.y = abs(cos(bob)) * 0.05
		viewmodel_target_transform.origin.x = sin(bob) * 0.05
		viewmodel_target_transform.origin.z = lerp(viewmodel_target_transform.origin.z, 0.0, delta * 16.0)
		if Input.is_action_just_released("weapon_next"):
			current_weapon += 1
		if Input.is_action_just_released("weapon_prev"):
			current_weapon -= 1
		current_weapon = wrapi(current_weapon, 0, inventory.size())
	else:
		viewmodel_target_transform.origin.y = -1.0
#	$UpperCollision/Camera/Armature002.transform = $UpperCollision/Camera/Armature002.transform.interpolate_with(viewmodel_target_transform, delta * 16)
	$UpperCollision/Camera/Armature002.transform = viewmodel_target_transform
	recoil *= pow(0.01, delta)
	bob += velocity.length() * delta / 2.0

func screen_shake(amplitude : float):
	current_screen_shake_amplitude = amplitude
	$ScreenShakeDuration.start()
	
func look():
	var amplitude = current_screen_shake_amplitude * $ScreenShakeDuration.time_left / $ScreenShakeDuration.wait_time
	var offset : Vector3 = Vector3.FORWARD
	offset = offset.rotated(Vector3.UP, rand_range(0.0, 2*PI))
	offset = offset.rotated(Vector3.UP.cross(offset), rand_range(0.0, 2*PI))
	offset = offset * pow(rand_range(0.0, 1.0), 0.5) * amplitude

	cam.transform.origin = offset

	var self_basis_z : Vector3 = look_dir * Vector3(1.0, 0.0, 1.0)
	self_basis_z = self_basis_z.normalized()
	self.transform.basis.z = self_basis_z
	self.transform.basis.x = self.transform.basis.y.cross(self_basis_z)
	self.transform.basis.x = self.transform.basis.x.normalized()

	var cam_basis_z : Vector3
	cam_basis_z.x = 0.0
	cam_basis_z.y = look_dir.dot(Vector3.UP)
	cam_basis_z.z = sqrt(1.0 - cam_basis_z.y*cam_basis_z.y)
	cam.transform.basis.z = cam_basis_z.normalized()
	cam.transform.basis.y = cam_basis_z.cross(cam.transform.basis.x)
	cam.transform.basis.y = cam.transform.basis.y.normalized()

	cam.transform = cam.transform.rotated(Vector3(1.0, 0.0, 0.0), recoil.x)
	cam.transform = cam.transform.rotated(Vector3(0.0, 1.0, 0.0), recoil.y)
	
func accel(_move_dir, accel, max_speed, delta):
	var new_velocity : Vector3 = velocity

	new_velocity += _move_dir * accel * delta

	if new_velocity.dot(_move_dir) < max_speed:
		velocity = new_velocity

func move(delta):
	velocity = move_and_slide(velocity, Vector3.UP)

#	$AudioStreamPlayer2.stream_paused = velocity.length() < 1.0 or (not is_on_floor())
#	if is_bat_form:
#		accel(move_dir, air_accel, ground_max_speed, delta)
#		var damp = pow(friction, delta)
#		velocity *= damp
#	else:
	var _accel : float = 0.0
	var _max_speed : float = 0.0
	var _friction : float = friction
	if is_on_floor():
		$AudioStreamPlayer2.stream_paused = velocity.length() < 1.0
		$AudioStreamPlayer3.volume_db = -60 + log(velocity.length() * pow(10.0, 10.0))
#			if move_dir.length() > 0:
#				$AudioStreamPlayer2.play()
#			else:
#				$AudioStreamPlayer2.stop()
#			if :
			
		_accel = ground_accel
		_max_speed = ground_max_speed
		if Input.is_action_pressed("move_jump"):
			velocity += jump_impulse * Vector3.UP
		if Input.is_action_pressed("move_crouch"):
			$UpperCollision.transform.origin.y = 0.5
			_accel = air_accel
			_max_speed = air_max_speed
			_friction = 0.25
			if just_crouched:
				velocity *= 1.5
			just_crouched = false
		else:
			$UpperCollision.transform.origin.y = 1.5
			just_crouched = true
		var damp = pow(_friction, delta)
		velocity.x *= damp
		velocity.z *= damp
	elif is_on_wall():
		$AudioStreamPlayer2.stream_paused = velocity.length() < 1.0
		var col = get_last_slide_collision()
		if Input.is_action_pressed("move_jump"):
#				var perpendicular = Vector3.UP.cross(col.normal).normalized()
			var _jump_dir = col.normal + Vector3.UP
			_jump_dir = _jump_dir.normalized()
			velocity += _jump_dir * jump_impulse * 1.4
		else:
			velocity -= col.normal * 32.0 * delta
#			if -col.normal.dot(look_dir) < 0.7:
		_accel = ground_accel
		_max_speed = ground_max_speed
		velocity.y += gravity * delta / 2.0
		var damp = pow(0.001, delta)
		velocity.y *= damp
		var boost = pow(2.0, delta)
		velocity.x *= boost
		velocity.z *= boost

	else:
		$AudioStreamPlayer2.stream_paused = true
		_accel = air_accel
		_max_speed = air_max_speed
	var _move_dir = move_dir * Vector3(1.0, 0.0, 1.0)
	_move_dir = _move_dir.normalized()
	accel(_move_dir, _accel, _max_speed, delta)
	velocity += Vector3.DOWN * gravity * delta
		


func weapon(delta):
	if inventory.size() < 1:
		return
	var weapon = inventory[current_weapon]
	var space_state = get_world().direct_space_state
	weapon_cooldown_timer -= delta
#	if not is_bat_form:
	if Input.is_action_pressed("weapon_primary"):
		if weapon_cooldown_timer <= 0.0:
			weapon.primary(self, space_state, delta)
			$AudioStreamPlayer.stream = weapon.primary_sound
			$AudioStreamPlayer.play()
	elif Input.is_action_pressed("weapon_secondary"):
		if weapon_cooldown_timer <= 0.0:
			weapon.secondary(self, space_state, delta)
			$AudioStreamPlayer.stream = weapon.secondary_sound
			$AudioStreamPlayer.play()
	elif weapon_cooldown_timer <= 0.0:
		weapon_cooldown_timer = 0.0

func add_weapon(weapon : Weapon):
	if not weapon in inventory:
		inventory.append(weapon)


func blood_suck():
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(cam.global_transform.origin, cam.global_transform.origin - cam.global_transform.basis.z * 2.5, [self])
	if result:
		if result["collider"] is Entity:
			result["collider"].queue_free()
			health += 50.0
			$AudioStreamPlayer4.play()

func dash():
	velocity = -cam.global_transform.basis.z * 32.0

func die():
	pass

func vamp(delta):
	var space_state = get_world().direct_space_state
	var result
	if sun and power_up[ItemDef.PowerUp.SUN_SCREEN] <= 0.0:
		result = space_state.intersect_ray(cam.global_transform.origin, cam.global_transform.origin + sun.global_transform.basis.z * 256.0, [self])
		if not result:
			health -= delta * 5.0
#	if is_bat_form:
#		bat_form_charge -= bat_form_depletion_rate * delta
#	else:
#		var multiplier = 1.0
#		if bat_form_lock:
#			multiplier = 0.5
#		bat_form_charge += bat_form_regeneration_rate * multiplier * delta
	
#	bat_form_charge = clamp(bat_form_charge, 0.0, bat_form_max_charge)
	
#	if bat_form_charge >= bat_form_max_charge:
#		bat_form_lock = false
#	elif bat_form_charge <= 0.0:
#		change_form(false)
#		bat_form_lock = true
	
	if Input.is_action_just_pressed("vamp_blood_suck"):
		blood_suck()
	if Input.is_action_just_pressed("vamp_dash"):
		dash()
#		change_form(!is_bat_form)

func power_up(delta):
	power_up[ItemDef.PowerUp.SUN_SCREEN] -= delta

#func change_form(to : bool):
#	is_bat_form = to and (not bat_form_lock)
#	if not bat_form_lock:
#		$Particles.restart()
#		$Particles2.restart()

		#	if inventory.size() > 0:
#		screen_shake()
#		new_velocity -= move_dir * (new_velocity.dot(move_dir) - max_speed)
		
	#		$ScreenShakeDuration.start()
	#		$UpperCollision/Camera/Armature002.transform.origin.z = weapon.aim_recoil
	#		current_screen_shake_amplitude = weapon.screen_shake
	#		$ScreenShakeDuration.start()
	#		$UpperCollision/Camera/Armature002.transform.origin.z = weapon.aim_recoil
	#		current_screen_shake_amplitude = weapon.screen_shake

		#	$UpperCollision/Camera/Armature002.transform.origin.y = abs(cos(bob)) * 0.04
#	$UpperCollision/Camera/Armature002.transform.origin.x = sin(bob) * 0.04
#	$UpperCollision/Camera/Armature002.transform.origin.z = lerp($UpperCollision/Camera/Armature002.transform.origin.z, 0.0, delta * 8.0)

#		$Particles.restart()
#		$Particles2.restart()
#		if is_bat_form:
#			$BatFormDuration.start()
		
#			bullet_hole_instance.global_transform.basis.x = shoot_dir.cross(collision_normal).normalized()
#			var shoot_dir = -$UpperCollision/Camera/RayCast.global_transform.basis.z
#			var collision_normal = $UpperCollision/Camera/RayCast.get_collision_normal()
#			var collision_point = $UpperCollision/Camera/RayCast.get_collision_point()
#		if $UpperCollision/Camera/RayCast.is_colliding():
#	new_origin.x = pow(rand_range(0.0, 1.0), 0.5) * amplitude
#	new_origin.y = pow(rand_range(0.0, 1.0), 0.5) * amplitude
#	new_origin.z = pow(rand_range(0.0, 1.0), 0.5) * amplitude
#	cam.transform.origin = new_origin
#		var cam_origin = $UpperCollision/Camera.global_transform.origin
#		var cam_dir = -$UpperCollision/Camera.global_transform.basis.z
#		for i in range(weapon.bullet_count):
#			var spread_dir : Vector3 = cam_dir
#			spread_dir = spread_dir.rotated($UpperCollision/Camera.global_transform.basis.x, rand_range(0.0, weapon.spread))
#			spread_dir = spread_dir.rotated(cam_dir, rand_range(0.0, 2*PI))
#			var result = space_state.intersect_ray(cam_origin, cam_origin + spread_dir * 256.0, [self])
#			if result:
#				var collision_point = result["position"]
#				var collision_normal = result["normal"]
#				var bullet_hole_instance = load("res://bullet_hole.tscn").instance()
#				result["collider"].add_child(bullet_hole_instance)
##				get_tree().current_scene.add_child(bullet_hole_instance)
#				bullet_hole_instance.global_transform.origin = collision_point + collision_normal * 0.001
#				bullet_hole_instance.global_transform.basis.z = collision_normal.normalized()
#				bullet_hole_instance.global_transform.basis.x = cam_dir.cross(collision_normal).normalized()
#				bullet_hole_instance.global_transform.basis.y = bullet_hole_instance.global_transform.basis.z.cross(bullet_hole_instance.global_transform.basis.x).normalized()
#		velocity += -cam_dir * weapon.world_recoil
#		recoil.x += weapon.aim_recoil

#	var amplitude = current_screen_shake_amplitude * $ScreenShakeDuration.time_left / $ScreenShakeDuration.wait_time
#	var offset : Vector3 = Vector3.FORWARD
#	offset = offset.rotated(Vector3.UP, rand_range(0.0, 2*PI))
#	offset = offset.rotated(Vector3.UP.cross(offset), rand_range(0.0, 2*PI))
#	offset = offset * pow(rand_range(0.0, 1.0), 0.5) * amplitude
#
#	cam.transform.origin = offset
#		var lateral_dir : Vector3
#		lateral_dir = 
#		lateral_dir = lateral_dir.normalized()
#		print(acos(look_dir.dot(Vector3.UP)), " | ", px_to_rad(-event.relative.y))
#		if px_to_rad(-event.relative.y) < acos(look_dir.dot(Vector3.UP)):
#			if inventory.size() > 0:
#				var weapon = inventory[current_weapon]
#				var space_state = get_world().direct_space_state
#			if inventory.size() > 0:
#				var weapon = inventory[current_weapon]
#				var space_state = get_world().direct_space_state
			#			var damp = pow(0.0001, delta)
#			velocity.y *= damp
#			weapon_cooldown_timer = weapon.cooldown
#			weapon_cooldown_timer = weapon.cooldown
			#			velocity.z *= damp
#			if Input.is_action_pressed("move_jump"):
#				velocity += jump_impulse * Vector3.UP
#	weapon.process(
#		self,
#		space_state,
#		Input.is_action_pressed("weapon_primary"),
#		Input.is_action_pressed("weapon_secondary"),
#		delta
#	)
#	if not is_bat_form:
#
#		if Input.is_action_pressed("weapon_primary"):
#			weapon.primary(self, space_state, delta)
#		if Input.is_action_just_pressed("weapon_secondary"):
#			weapon.secondary(self, space_state, delta)
