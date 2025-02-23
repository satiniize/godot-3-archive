extends Node2D


var current_item_id = null
var item_data = preload("res://player/weapons/item_data.tres")
onready var collider = $Area2D/CollisionShape2D


func _physics_process(delta):
	if current_item_id == null:
		return
	var current_item_data = item_data.items[current_item_id]
#	print(current_item_data)
	match current_item_data["type"]:
		item_data.Type.WEAPON_AREA:
			$Area/CollisionShape2D.shape.radius = current_item_data["range"]
			#area2d with angle check
			if Input.is_action_just_pressed("attack_primary"):
				if not $AnimationPlayer.is_playing():
					for body in $Area.get_overlapping_bodies():
						body.damage(10)
					$AnimationPlayer.play("swing")
					$AnimationPlayer.playback_speed = $AnimationPlayer.current_animation_length / current_item_data["cooldown"]
#			pass #broadsword
		item_data.Type.WEAPON_RAYCAST:
			$RayCast.look_at(get_global_mouse_position())
			if Input.is_action_just_pressed("attack_primary"):
				if not $AnimationPlayer.is_playing():
					if $RayCast.is_colliding():
						var target = $RayCast.get_collider()
						target.damage(10)
					$AnimationPlayer.play("stab")
			#uhh i guess this might be the same with weapon stab
#			pass #lasers, fast bullets
		item_data.Type.WEAPON_PROJECTILE:
			#summon projectile instance, swappable texture
			pass #rockets, and whatnot
		item_data.Type.CONSUMABLE:
			#add buff or debuff to player
			pass #heals, boosts, single use
		item_data.Type.RELIC:
			#passive buff
			pass #keep in inventory to get buff, infinite
		item_data.Type.SPAWNER:
			#spawn npc
			pass #spawn npc, helper to help warrior and mainly for gamemaster
