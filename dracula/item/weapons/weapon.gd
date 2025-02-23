class_name Weapon

extends Resource

export(String) var name

#export(int) var ammo

export(PackedScene) var bullet_hole
export(float) var world_recoil
export(float) var aim_recoil

export(int) var bullet_count = 1
export(float) var spread = 0.0 #should be in radians

export(float) var screen_shake

export(float) var phase_speed

export(float) var draw_speed
export(float) var sheathe_speed

export(float) var primary_cooldown
export(float) var secondary_cooldown

export(AudioStream) var primary_sound
export(AudioStream) var secondary_sound

func process(player, space_state, primary_input, secondary_input, delta):
	pass

func primary(player, space_state, delta):
	pass

func secondary(player, space_state, delta):
	pass

#func reload():
#	clip_ammo = min(clip_ammo, reserve_ammo)
#	reserve_ammo -= min(clip_ammo, reserve_ammo)
