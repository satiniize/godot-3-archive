extends KinematicBody

#-#-# PLAYER SPECIFIC THINGS #-#-#
onready var current_weapon := get_node("CollisionShapeUpper/CamGroup/exampleGun")
onready var cast := get_node("CollisionShapeUpper/CamGroup/RayCast")
var mouse_sensitivity = -0.001
onready var cam_group := get_node("CollisionShapeUpper/CamGroup")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cast.add_exception(self)

func _input(event) -> void:
	if event is InputEventMouseMotion:
		rotation.y += event.relative.x * mouse_sensitivity
		cam_group.rotation.x += event.relative.y * mouse_sensitivity

func handle_crouch(delta: float):
	if is_on_floor():
		if !Input.is_action_pressed("move_crouch") and !$CanStand.is_colliding():
			$CollisionShapeUpper.translation.y = float_interpolate($CollisionShapeUpper.translation.y, 2.25, delta * 8.0)
		else:
			$CollisionShapeUpper.translation.y = float_interpolate($CollisionShapeUpper.translation.y, 0.75, delta * 8.0)

func update_debug_info():
	$CanvasLayer/Debug/FPS.text = str(Performance.get_monitor(Performance.TIME_FPS))
	$CanvasLayer/Debug/Velocity.text = str(velocity)
	$CanvasLayer/Debug/Speed.text = str(velocity.length())
	$CanvasLayer/Debug/Stamina.text = str(stamina)
	
func _physics_process(delta):
	var forward_input = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	var side_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var jump_input = Input.is_action_pressed("move_jump")
	var run_input = Input.is_action_pressed("move_run")
	var forward = get_global_transform()[2].rotated(Vector3.UP, PI) * forward_input
	var side = get_global_transform()[2].rotated(Vector3.UP, PI/2.0) * side_input
	accel_dir = (forward * forward_move + side * side_move).normalized()
	handle_move(accel_dir, jump_input, run_input, Input.is_action_pressed("move_crouch"), delta)
	handle_crouch(delta)
	update_debug_info()
#-#-# PLAYER SPECIFIC THINGS #-#-#

#-#-# ENTITY MOVEMENT #-#-#
export(float) var mass = 1000.0
export(float) var walk_force = 20000.0
#export(float) var 
export(float) var drag_coefficient = 1.3
export(float) var reference_area = 2.0
export(float) var air_density = 1.2
export(float) var friction = 0.5
export(float) var thrust_force = 20000
export(float) var jump_height = 2.0
var velocity := Vector3.ZERO
var accel_dir := Vector3.ZERO
var fly_dir := Vector3.ZERO
var walk_dir := Vector3.ZERO
var boost_is_active := false
var fly_mode := false
export(float) var max_speed_walk := 4.0
export(float) var max_speed_crouch := 2.0
export(float) var max_speed_run := 12.5
export(float) var max_speed_air := 1.0
export(float) var stop_speed := 3.0
var forward_move := 1.0
var side_move := 1.0
export(float) var jump_force := 5.0
var stamina_amount := 1.0
var stamina := stamina_amount
var stamina_rate := 0.5
var gravity := 9.8
## MECH SPECIFIC PARAMS##
var walking_efficiency = 0.8

	
func float_interpolate(_start: float, _end: float, _bias: float) -> float:
	return _start * (1.0 - _bias) + _end * _bias

func handle_accel(_wish_dir: Vector3, _delta: float) -> void:
	var accel = walk_force / mass * (2.0 if Input.is_action_pressed("move_run") else 1.0)
	var walking_friction = walk_force * (1.0 - walking_efficiency) / mass
	var final_vel = velocity + _wish_dir * accel * _delta
	if final_vel.dot(_wish_dir) < max_speed_run:
		velocity = final_vel
	else:
		velocity += (max_speed_run - final_vel.length()) * _wish_dir
#	velocity += min(accel, max_speed_run - accel * _delta) * _wish_dir * _delta
#	velocity -= velocity.normalized() * walking_friction * _delta
#	var delta_dist = accel * _delta
#	var distance = delta_dist * _delta
#	var _force = power * _delta / distance
#	var resolution = 3
#	var final_force = _force
#	velocity += power / max(velocity.length(), 0.1) / mass * _delta * _wish_dir

#	force = sqrt(power / mass)
func handle_drag(delta: float) -> void:
	var flow_velocity = velocity.length()
	var drag_force = drag_coefficient * reference_area * air_density * flow_velocity*flow_velocity / 2.0
	velocity += (-velocity.normalized() * drag_force / mass) * delta

func handle_friction(_wish_dir: Vector3, delta: float) -> void:
	var normal_force = mass * gravity
	var friction_force = normal_force * friction
#	var friction_force = normal_force * friction * (velocity.normalized().dot(-_wish_dir) + 1) / 2.0
	if friction_force / mass * delta > velocity.length():
		velocity = Vector3.ZERO
	else:
		velocity += (-velocity.normalized() * friction_force / mass) * delta
	
func handle_boost(wish_boost: bool, delta: float):
	if fly_mode:
		velocity += fly_dir * thrust_force / mass * delta

func handle_fly(delta: float):
	if fly_mode:
		var zero_gravity_force = min(gravity, thrust_force / mass)
		velocity.y += zero_gravity_force * delta
		if is_on_floor():
			fly_mode = false
			

func handle_jump(_wish_jump: bool, _on_floor: bool, _on_ceiling: bool, _delta: float):
	if Input.is_action_just_pressed("move_jump"):
		if _on_floor:
			$FlyWindow.start()
			velocity.y += sqrt(2 * gravity * jump_height)
		else:
			if !$FlyWindow.is_stopped():
				boost_is_active = !boost_is_active

func handle_input():
	var longitudinal_input = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	var vertical_input = Input.get_action_strength("move_jump") - Input.get_action_strength("move_crouch")
	var lateral_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	fly_dir = Vector3(lateral_input, vertical_input, longitudinal_input).normalized().rotated(Vector3.UP, rotation.y)
	walk_dir = Vector3(lateral_input, 0.0, longitudinal_input).rotated(Vector3.UP, rotation.y).normalized()
#	if Input.is_action_just_pressed("move_boost"):
#		boost_is_active = !boost_is_active
	if Input.is_action_just_pressed("move_jump"):
		if $FlyWindow.is_stopped():
			$FlyWindow.start()
		else:
			fly_mode = !fly_mode

func handle_move(accel_dir: Vector3, jump_input: bool, run_input: bool, crouch_input: bool, delta: float):
	handle_input()
	velocity = move_and_slide(velocity, Vector3.UP)
	var on_floor = is_on_floor()
	var on_ceiling = is_on_ceiling()
	handle_boost(boost_is_active, delta)
	handle_drag(delta)
	if on_floor: 
		handle_accel(
			walk_dir,
			delta
			)
		handle_friction(walk_dir, delta)

	handle_jump(jump_input, on_floor, on_ceiling, delta)
	handle_fly(delta)
	velocity.y -= gravity * delta
#-#-# ENTITY MOVEMENT #-#-#





#####################################################################
#	velocity += _wish_dir * accel * _delta
#	delta_energy = power * delta
#	force * distance = power * time
#	force = power * time / distance
#	force * (velocity * time + 0.5 * accel * time^2) = power * time
#	force * velocity = power
#	power / ve
#	force = power / (velocity + 0.5 * force / mass * time)
#	force * (velocity + 0.5 * force / mass * accel_dir * time) - power = 0
#	0.5 * accel_dir * time / mass * force^2 + velocity * force - power
#	var constant = 0.5 * accel_dir * time / mass
#	force^2 + velocity / (0.5 * accel_dir * time / mass) * force - power / (0.5 * accel_dir * time / mass)
#	force^2 + velocity / constant * force - power / constant = 0
#	x + y = velocity / constant
#	x * y = power / constant
#	x = power / consant / y
#	power / consant / y + y = velocity / constant
#	0.5 * accel_dir * time / mass * force^2 + velocity * force - power = 0
#	(force + a) * (force + b) = 0 
#	force * velocity + 0.5 * force^2 / mass * time = power
#	force * velocity * time + 0.5 * force * accel * time^2 = power * time
#	force * delta_dist = power * delta
#	force * (accel * delta) = power * delta
#	force * (force / mass * delta) = power * delta
#	force^2 / mass = power
#func get_kinetic_energy(_wish_dir, delta):
#	#Delta velocity magnitude is defined as vt^2 - v0^2
#	var original_velocity = velocity
#	var delta_velocity_magnitude = 2.0 * power * delta / mass
#	#delta velocity magnitude is the absolute and scalar version
#	#since its defined as vt^2 - v0^2 it can be expanded to
#	#vt = velocity + accel_dir * amount
#	#vo = velocity
#	#delta_velocity = vt*vt.abs() - v0*v0.abs()	
#	#or ?
#	#vt = vt.dot(vt) * vt.normalized
#	#where vt.dot(vt) is vt^2 length and vt.normalized is the direction
#	#v0 = v0.dot(v0) * v0.normalized
#	#delta_velocity = vt - v0
#	#delta_velocity = vt.dot(vt) * vt.normalized * v0.dot(v0) * v0.normalized
#	#delta_velocity = vt.dot(vt) * vt / vt.length() * v0.dot(v0) * v0 / v0.length
#	#delta_velocity = vt.length() * vt - v0.length() * v0
#	#delta_velocity = vt.length() * vt - v0.length() * v0
#	var delta_velocity = delta_velocity_magnitude * accel_dir
#	var v0_squared = velocity*velocity.abs()
#	velocity += (delta_velocity_magnitude) * accel_dir
##	delta_velocity = vt_squared - v0_squared
##	vt_squared = v0_squared + delta_velocity
#	var vt_squared = v0_squared + delta_velocity
#	print((mass / 2.0 * (velocity.length_squared() - original_velocity.length_squared())) / (power * delta))
#	#delta velocity needs to be multiplied by |		power * delta / kinetic_energy
#	var v0_squared = velocity*velocity.abs()
#	var speed_magnitude = 1.0
#	var vt = velocity + _wish_dir * speed_magnitude
#	var vt_squared = vt*vt.abs()
#	var constant = mass / 2.0
#	var delta_velocity = (vt_squared - v0_squared).length()
#	var kinetic_energy = delta_velocity * constant
#	var ratio = kinetic_energy / power
#	print(ratio)
#	get_kinetic_energy(_wish_dir, _delta)
#	print(ratio)
	###
#	if ratio <= 1.0:

#	if _wish_jump:
#		if _on_floor:
#			if velocity.y < jump_force:
#				velocity.y = jump_force
#			$JumpTimer.start()
#		elif _on_ceiling:
#			$JumpTimer.stop()
#		elif !$JumpTimer.is_stopped():
#			if velocity.y < jump_force:
#				velocity.y = jump_force



#var wish_look := Vector2.ZERO
#var mouse_movement: Vector2 = Vector2.ZERO
#var recoil_offset: Vector2 = Vector2.ZERO
#var finalized_recoil: Vector2 = Vector2.ZERO
#export(PackedScene) var bullet_decal
#		mouse_movement += event.relative

#func handle_look(_wish_look: Vector2, recoil: Vector2, delta: float):
#	var bias = current_weapon.get_node("RecoilTimer").time_left / current_weapon.get_node("RecoilTimer").wait_time
#	finalized_recoil = recoil * bias
#	wish_look += _wish_look * mouse_sensitivity
#	wish_look.y = clamp(wish_look.y, -PI/2, PI/2)
#	rotation.y = wish_look.x# + finalized_recoil.x
#	cam_group.rotation.x = wish_look.y# + finalized_recoil.y
#	mouse_movement = Vector2.ZERO

#func handle_shoot(delta: float):
#	var primary_shoot = Input.is_action_pressed("attack_primary")
#	var cast_is_colliding = (cast as RayCast).is_colliding()
#	if current_weapon.handle_fire(primary_shoot, delta):
#		$CollisionShapeUpper/CamGroup/AK47.translation.z = -0.1
#		$CollisionShapeUpper/CamGroup/AK47.rotation_degrees.x = 5
#		if cast_is_colliding:
##			if cast.get_collider() is LivingBody:
##				(cast.get_collider() as LivingBody).damage(20.0)
##			else:
#				current_weapon.summon_bullet_decal(bullet_decal, cast.get_collider(), cast.get_collision_point(), cast.get_collision_normal())
#		recoil_offset = current_weapon.get_recoil(finalized_recoil, delta)
#	if current_weapon.get_node("RecoilTimer").is_stopped():
#		recoil_offset = Vector2.ZERO

#func handle_recoil_anim(delta: float):
#	$CollisionShapeUpper/CamGroup/AK47.translation.z = float_interpolate($CollisionShapeUpper/CamGroup/AK47.translation.z, -0.2, delta * 16.0)
#	$CollisionShapeUpper/CamGroup/AK47.rotation_degrees.x = float_interpolate($CollisionShapeUpper/CamGroup/AK47.rotation_degrees.x, 0, delta * 16.0)

#	handle_shoot(delta)
#	handle_recoil_anim(delta)
#	handle_look(mouse_movement, recoil_offset, delta)


#export(float) var accel = 20.0
#	var _kinetic_energy = power * _delta
#	velocity += _wish_dir
#	_wish_speed = min(_wish_speed, _max_speed)
#	var _current_velocity = velocity
#	_current_velocity.y = 0.0
#	var _current_speed = _current_velocity.length()
#	velocity += accel * (max(_wish_speed - _current_speed, 0.0) / _wish_speed) * _wish_dir * _delta
	
#	_wish_speed = min(_wish_speed, _max_speed)
#	var _current_speed = velocity.dot(_wish_dir)
#	var _add_speed = _wish_speed - _current_speed
#	if _add_speed < 0.0:
#		return
#	var _accel_speed = accel * _wish_speed * _delta
#	_accel_speed = min(_accel_speed, _add_speed)
#	velocity += _accel_speed * _wish_dir
#	var speed = velocity.length()
#	var control = max(speed, stop_speed)
#	var drop = control * friction * delta
#	var new_speed = speed - drop
#	new_speed = max(new_speed, 0.0)
#	velocity = velocity.normalized() * new_speed

#func handle_run(wish_crouch: bool, wish_run: bool, delta: float) -> float:
#	if wish_crouch:
#		return max_speed_crouch
#	elif wish_run:
#		stamina -= stamina_rate * delta
#		stamina = clamp(stamina, 0.0, stamina_amount)
#		if stamina > 0.0:
#			return max_speed_run
#		else:
#			return max_speed_walk
#	else:
#		stamina += stamina_rate * delta
#		stamina = clamp(stamina, 0.0, stamina_amount)
#		return max_speed_walk
#	else:
#		accel(
#			accel_dir,
#			movement_speed,
#			max_speed_air,
#			delta
#			)
#	else:
#		if Input.is_action_pressed("move_crouch"):
#			velocity.y -= boost_thrust / mass * delta
#	var movement_speed = handle_run(crouch_input, run_input, delta)
#	fly(Input.is_action_pressed("move_up"), Input.is_action_pressed("move_down"), delta)
#func fly(wish_up: bool, wish_down: bool, delta: float):
#	velocity.y += boost_thrust / mass * delta * (float(wish_up) - float(wish_down))
