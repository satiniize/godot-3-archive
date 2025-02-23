extends RayCast

var velocity = Vector3.ZERO
var initial_speed = 64
var initial_dir = Vector3.ZERO
var gravity = 24
var has_collided
var player

func launch(pos: Vector3, dir: Vector3):
	global_transform.origin = pos
	velocity = dir * initial_speed
	initial_dir = dir
	set_physics_process(true)


func _physics_process(delta):
	if is_colliding():
		has_collided = true
		velocity = Vector3.ZERO
		gravity = 0.0
		global_transform.origin = get_collision_point()
		on_collide()
		enabled = false
	elif not has_collided:
		velocity += gravity * Vector3.DOWN * delta
		cast_to = velocity * delta
		global_transform.origin += velocity * delta
		var trail_pos = global_transform.origin + cast_to / 2.0
		$Trail.global_transform.origin = trail_pos
		$Trail.global_transform.basis.y = velocity.normalized()
		$Trail.global_transform.basis.x = $Trail.global_transform.basis.y.cross(Vector3.UP).normalized()
		$Trail.global_transform.basis.z = $Trail.global_transform.basis.y.cross($Trail.global_transform.basis.x).normalized()

func on_collide():
	$Trail.hide()
	var explosion = preload("res://item/weapons/explosion.tscn")
	var normal = get_collision_normal()
	var cross_product1 = cast_to.cross(normal).normalized()
	var cross_product2 = cross_product1.cross(normal).normalized()
	var explosion_instance = explosion.instance()
	get_tree().current_scene.add_child(explosion_instance)
	explosion_instance.global_transform.origin = global_transform.origin + normal * 0.001
	explosion_instance.global_transform.basis.z = normal
	explosion_instance.global_transform.basis.x = cross_product2.normalized()
	explosion_instance.global_transform.basis.y = cross_product1.normalized()
	explosion_instance.explode()
#	$MeshInstance/Particles.restart()
#	$MeshInstance/Particles2.restart()
#	for body in $MeshInstance/Area.get_overlapping_bodies():
#		if body is Entity:
#			var distance = (body.global_transform.origin - global_transform.origin)
#			body.damage(64.0 / max(distance.length(), 1.0))
#			body.velocity += 32.0 / max(distance.length(), 1.0) * distance.normalized()
#			if body is Player:
#				body.screen_shake(0.5 / max(distance.length(), 1.0))
#	$MeshInstance/AudioStreamPlayer3D.play()
#	if get_collider().get("health") != null:
#		get_collider().damage(10)
#		handle_drag(delta)
#		cast_to = Vector3.ZERO
#		gravity = 0
#		has_collided = true
#		$MeshInstance/Particles.emitting = false
#	cast_to = velocity * delta
	
#func handle_drag(delta: float) -> void:
#	var flow_velocity = velocity.length()
#	var drag_force = drag_coefficient * reference_area * air_density * flow_velocity*flow_velocity / 2.0
#	velocity += (-velocity.normalized() * drag_force / mass) * delta
#		$MeshInstance.global_transform.origin = global_transform.origin
	
