#	wish_dir = player_dir

#func custom_dot(a: Vector3, b: Vector3):
#	return a.x*b.x + a.y*b.y + a.z*b.z

#	cur_dir = wish_dir
#	var angle = acos(custom_dot(cur_dir, wish_dir))

#	self.transform = self.transform.interpolate_with(self_transform, delta * speed)
#	$Particles.transform = $Particles.transform.interpolate_with(look_transform, delta * speed)
#	$Particles.transform.basis.z = new_look_basis.normalized()
#	$Particles.transform.basis.y = new_look_basis.cross($Particles.transform.basis.x).normalized()
#	var self_basis_z : Vector3 = player_dir * Vector3(1.0, 0.0, 1.0)
#	self_basis_z = self_basis_z.normalized()
#	self.transform.basis.z = self_basis_z
#	self.transform.basis.x = self.transform.basis.y.cross(self_basis_z)
#	self.transform.basis.x = self.transform.basis.x.normalized()
#
#	var cam_basis_z : Vector3
#	cam_basis_z.x = 0.0
#	cam_basis_z.y = player_dir.dot(Vector3.UP)
#	cam_basis_z.z = sqrt(1.0 - cam_basis_z.y*cam_basis_z.y)
#	$Particles.transform.basis.z = cam_basis_z.normalized()
#	$Particles.transform.basis.y = cam_basis_z.cross($Particles.transform.basis.x)
#	$Particles.transform.basis.y = $Particles.transform.basis.y.normalized()
#	var cam_basis_z : Vector3
#	$Particles.global_transform.basis.z = player_dir
#	$Particles.global_transform.basis.x = Vector3.UP.cross(player_dir).normalized()
#	$Particles.global_transform.basis.y = $Particles.global_transform.basis.x.cross(player_dir)
#	$Particles.process_material.direction = player_dir
#var max_speed = 10.0
#var accel = 64.0
#export(NodePath) var player_path
#onready var player = get_node(player_path)
#		var total_dir : Vector3
			
			#		if player.is_bat_form:
#			base_dir = Vector3.ZERO
#		else:
#			base_dir = get_path_dir(player.global_transform.origin)
			#	else:
#		var friends = $Area.get_overlapping_bodies()

			#		total_dir = base_dir + dir
#		total_dir = total_dir.normalized()
#			var distance = enemy.global_transform.origin - other.global_transform.origin
#				if distance.length() < 32.0:
#					new_dir += distance.normalized() * seperation_weight / distance.length_squared()
#		if new_dir.length() < 32.0:
#			enemy.dir = new_dir.normalized()
#		else:k
#			enemy.dir = Vector3.ZERO
#		var enemy = get_child(i)
#		for j in range(get_child_count()):
#			var other = get_child(j)
#			if other != enemy:
#	for i in range(get_child_count()):
#		var new_dir : Vector3
#		var enemy = get_child(i)
#		for j in range(get_child_count()):
#			var other = get_child(j)
#			if other != enemy:
#				var distance = enemy.global_transform.origin - other.global_transform.origin
#				if distance.length() < 32.0:
#					new_dir += distance.normalized() * seperation_weight / distance.length_squared()
#		if new_dir.length() < 32.0:
#			enemy.dir = new_dir.normalized()
#		else:
#			enemy.dir = Vector3.ZERO


#	if player != null:
#		var friends = get_tree().get_nodes_in_group("enemies")
#		if friends.size() > 0:
#			var total_dir : Vector3 = Vector3.ZERO
#			total_dir += sep(friends) * 2.0
#			total_dir += ali(friends)
#			total_dir += coh(friends)
#			total_dir += get_path_dir(player.global_transform.origin) * 4.0
#			total_dir = total_dir.normalized()
#			var accel = 4.0
#			velocity.x = total_dir.x * accel
#			velocity.z = total_dir.z * accel
#			velocity = move_and_slide(velocity, Vector3.UP)



#		if total_dir.length() > 0.0:
#			orient(total_dir, delta)
		
#	$PlayerVisibility.look_at(player.global_transform.origin + Vector3(0.0, 0.5, 0.0), Vector3.UP)
#	decay_sus_source(delta)
	
	#start targeting
#	var target_pos = get_sussiest_pos()
#	if $PlayerVisibility.is_colliding():
#		if $PlayerVisibility.get_collider() == player and not Debug.oblivius_enemy:
#			target_pos = player.global_transform.origin
#			if (player.global_transform.origin - global_transform.origin).length() < 1.0:
#				jumpscare()
#	if target_pos == null:
#		var pot_children = pot.get_children()
#		var delta_pos = pot_children[pot_index].global_transform.origin
#		var threshold = 0.5
#		if (delta_pos - global_transform.origin).length() < threshold:
#			pot_index = randi() % pot_children.size()
#		var node = pot_children[pot_index]
#		target_pos = node.global_transform.origin


#func _on_AttackTimer_timeout():
#	pass # Replace with function body.

#func sep(friends : Array):
#	if friends.size() <= 0:
#		return
#	var _dir : Vector3
#	for fren in friends:
#		var dist : Vector3 = global_transform.origin - fren.global_transform.origin
#		if dist.length() > 0.0:
#			dist = dist / dist.length_squared()
#			_dir += dist
#	return _dir
#
#func ali(friends : Array):
#	if friends.size() <= 0:
#		return
#	var _dir : Vector3
#	for fren in friends:
#		_dir += fren.velocity
#	return _dir.normalized()
#
#func coh(friends : Array):
#	if friends.size() <= 0:
#		return
#	var _avg : Vector3
#	for fren in friends:
#		_avg += fren.global_transform.origin
#	_avg = _avg / friends.size()
#	var _dir = _avg - global_transform.origin
#	return _dir.normalized()
		#		velocity.x = _dir.x * accel
#		velocity.z = _dir.z * accel
#		var accel = 10.0
#		atk(friends)
		
#func sep(friends : Array):#		var friends = $Area.get_overlapping_bodies()
#		_dir += sep(friends)
#	var sep_dir : Vector3
#	for fren in friends:
#		if fren != self:
#			var _dist = self.global_transform.origin - fren.global_transform.origin
#			sep_dir += _dist / _dist.length_squared()
#	return sep_dir.normalized()
#	if sep_dir.length() / results.size() > 1.0:
#		return Vector3.ZERO
#	else:
#		return sep_dir.normalized()
#	if dir.length() < 2.0:
#		dir = dir * (dir.length() - 1.0)
#	elif dir.length() < 1.0:
#		dir = -dir * (1.0 - dir.length())
#		if _dir.length() > 0.0:
#			orient(_dir, delta)#		velocity += _dir * 16.0 * delta
#		var damp = pow(0.5, delta)
#		velocity *= damp
#		move_and_slide(velocity)
#		if l_dist < r_dist:
#			_dir = target_pos_l - global_transform.origin
#		else:#		target_pos_l = base - h_offset + v_offset
#		target_pos_r = base + h_offset + v_offset
#		var l_dist = (target_pos_l - global_transform.origin).length()
#		var r_dist = (target_pos_r - global_transform.origin).length()
#var target_pos_l : Vector3
#var target_pos_r : Vector3
#var max_speed = 10.0
#var accel = 128.0
