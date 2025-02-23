class_name WeaponBase

extends Spatial


export(String) var weapon_name
enum FireType{SINGLESHOT, BURTS, SEMIAUTO, FULLAUTO}
export(float) var weapon_rps
export(float) var damage
#export(float) var recoil_cooldown
export(float) var reload_cooldown
export(int) var magazine_size
var bullet_count: = 0
var weaponTimer: float = 0.0
#var reloadTimer = reloadCooldown
#var recoilCooldownTimer: float = recoilCooldown
var yVectorDistance: float
export(NodePath) var path_to_recoilPattern
onready var recoilPattern := get_node("recoilPattern")
export(NodePath) var path_to_recoilPatternFollow
onready var recoilPatternFollow := get_node("recoilPattern/recoilPatternFollow")
onready var recoilPatternPoints: PoolVector2Array = recoilPattern.get_curve().get_baked_points()
var recoilProgress = 0.0
var savedRecoilProgress = 0.0
enum{IDLE, FIRING}
var weaponState = IDLE
#onready var bulletLeft: int = magazineSize

func _physics_process(delta):
	update_recoil_cooldown(delta)

func getPoolVector2ArrayYVectorMinMax(array: PoolVector2Array):
	var yVectorMin: float = array[0].y
	var yVectorMax: float = array[0].y
	for member in array:
		yVectorMin = min(yVectorMin, member.y)
		yVectorMax = max(yVectorMax, member.y)
	return [yVectorMin, yVectorMax]

func _ready():
	var minMax = getPoolVector2ArrayYVectorMinMax(
		recoilPatternPoints
	)
	yVectorDistance = minMax[1] - minMax[0]

func handle_fire(wishFire: bool, delta: float):
	#Step the timer
	weaponTimer -= delta
	#Prevent the timer from going negative
	weaponTimer = max(weaponTimer, 0.0)
	#True if weaponTimer reaches 0
	var canShoot = weaponTimer <= 0.0 and $ReloadTimer.is_stopped()
	#Check if player wants to shoot and if gun is able to fire
	var output = wishFire and canShoot
	if output:
		#Reset the timer to the inverse of RPS
		weaponTimer = 1.0 / weapon_rps
		weaponState = FIRING
	else:
		weaponState = IDLE
	#Return
	return output
 
func get_recoil(prev_recoil: Vector2, delta: float):
	recoilProgress = min(recoilProgress, 1.0)
	if $ReloadTimer.is_stopped():
		bullet_count += 1		
		if $RecoilTimer.is_stopped():
			recoilProgress = 0.0
		else:
			recoilProgress *= $RecoilTimer.wait_time / ($RecoilTimer.wait_time - 1.0 / weapon_rps)
		var control: Vector2 = get_recoil_pattern_offset()
		recoilProgress += 1.0 / float(magazine_size)
		var nextShot: Vector2 = get_recoil_pattern_offset()
		$RecoilTimer.start()#		recoilCooldownTimer = recoilCooldown
		savedRecoilProgress = recoilProgress
		if bullet_count > magazine_size - 1:
			if true:
				$ReloadTimer.start()#				reloadTimer = reloadCooldown
				bullet_count = 0
			else:#Use for debug
				recoilProgress -= 9.0 / float(magazine_size)
		return prev_recoil * get_recoil_multiplier(get_node("RecoilTimer").wait_time) + ((control - nextShot) / yVectorDistance * 0.33 + getInnacuracy())

func get_recoil_pattern_offset():
	recoilProgress = min(recoilProgress, 1.0)
	recoilPatternFollow.offset = 	(recoilProgress #Fraction of bulletCount over magazineSize
									*recoilPattern.curve.get_baked_length() #Get Total Length
									*0.999) #Prevent Looping
	return recoilPatternFollow.global_position

func update_recoil_cooldown(delta: float):
	recoilProgress = savedRecoilProgress * $RecoilTimer.time_left / $RecoilTimer.wait_time
	recoilProgress = min(recoilProgress, 1.0)
	#If player is holding down shoot then the ratio should only be 
	#		(recoilCooldown - 1.0/weaponRPS) /
	#				recoilCooldown
	#For the AK the result is a ratio of 0.8
	#If (say 1.0 - ratio) * savedRecoilProgress is equal to 1.0 / magazineSize
	#recoilProgress would halt and not continue rising
	#For the AK the maximumRecoilProgress it has is 0.1666
	#but from debugging its 0.153846
	#1.0 / 0.153846 is 6.5
	#Fix in later iteration pls

func get_recoil_multiplier(value: float): #Should probably revamp this as to be able to fix bugs but eh
	return 10.0 / (10.0 - (1.0 / value))#Actual black magic
#		recoilOffset *= 1.6666# recoil cooldown 0.25 s 1/4 == 10/6
#		recoilOffset *= 2# recoil cooldown 0.2 s 1/5 == 10/5
#		recoilOffset *= 1.1111# recoil cooldown 1 s 1 == 10/9
#		recoilOffset *= 1.25# recoil cooldown 0.5 s 1/2 == 10/8
#		recoilOffset *= 10 / 7# recoil cooldown 0.5 s 1/2 == 10/8

func getInnacuracy():
	return Vector2(rand_range(0.01, -0.01), rand_range(0.01, -0.01))

func summon_bullet_decal(bullet_decal: PackedScene, object: Object, _collision_point: Vector3, _collision_normal: Vector3):
	var bullet_decal_instance: Sprite3D = bullet_decal.instance()
#	if object.get_material_override() is SpatialMaterial:
#		(bullet_decal_instance.get_child(0) as CPUParticles).mesh.surface_get_material(0).set_shader_param("surface_texture", object.get_material_override().albedo_texture)
#		(bullet_decal_instance.get_child(0) as CPUParticles).mesh.surface_get_material(0).set_shader_param("albedo", object.get_material_override().albedo_color)
	object.add_child(bullet_decal_instance)
	bullet_decal_instance.global_transform.origin = _collision_point + _collision_normal * 0.01
	bullet_decal_instance.look_at(-_collision_normal + bullet_decal_instance.get_global_transform().origin + Vector3(rand_range(-0.01, 0.01), rand_range(-0.01, 0.01), rand_range(-0.01, 0.01)), Vector3.UP)
	bullet_decal_instance.get_child(0).restart()
