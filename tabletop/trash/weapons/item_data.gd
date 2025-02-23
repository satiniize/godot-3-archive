extends Resource


enum Type{
	WEAPON_RAYCAST, #shortsword, lasers, fast bullets
	WEAPON_AREA, #broadsword
	WEAPON_PROJECTILE, #rockets, and whatnot
	CONSUMABLE, #heals, boosts, single use
	RELIC, #keep in inventory to get buff, infinite, passive
	SPAWNER #spawn npc, helper to help warrior and mainly for gamemaster
}


var items = {
	"dagger" : {
		"name" : "Dagger",
		"image" : preload("res://player/weapons/weapon_raycast/dagger/dagger.tres"),
		"type" : Type.WEAPON_RAYCAST,
		"damage" : 10,
		"range" : 32
	},
	"heal_pot" : {
		"name" : "Heal Pot",
		"image" : preload("res://player/weapons/consumable/heal_pot/heal_pot.tres"),
		"type" : Type.CONSUMABLE,
		"mode" : "add",
		"stats" : {
			"health" : 10
		}
	},
	"broadsword" : {
		"name" : "Broadsword",
		"image" : preload("res://player/weapons/weapon_area/broadsword/broadsword.tres"),
		"type" : Type.WEAPON_AREA,
		"damage" : 20,
		"range" : 32,
		"cooldown" : 0.5
	},
	"bigboy" : {
		"name" : "BigBoy Spawner",
		"image" : preload("res://player/weapons/spawner/bigboy/bigboy.tres"),
		"type" : Type.SPAWNER,
		"horde_size" : 1
	},
	"bow" : {
		"name" : "Bow",
		"image" : preload("res://player/weapons/weapon_projectile/bow/bow.tres"),
		"type" : Type.WEAPON_PROJECTILE,
		"projectile_radius" : 16,
		
	}
}
#var items = {
#	"weapons": {
#		#somehow i need to make this work for
#		"dagger" : Weapon.new(
#			"Dagger",
#			10,
#			load("res://player/weapons/sword/dagger/dagger.tres")
#		)
#	},
#	"consumables" : {
#
#	},
#	"relics" : {
#
#	},
#	"spawner" : {
#
#	}
#}


#var weapon = {
#	"dagger" : Weapon.new(
#		"Dagger",
#		10,
#		preload("res://player/weapons/sword/dagger/dagger.tres")
#	)
#}
#
#
#var consumables = {
#	"Heal" : {}
#}
#
#
#var relics = {
#	"charm" : {}
#}


#class Item:
#	var name
#	var texture
#	func class2dict():
#		pass
#	func dict2class():
#		pass
#
#
#class Weapon extends Item:
#	var damage
#	func _init(_name: String, _damage: int, _texture: Texture):
#		self.name = _name
#		self.damage = _damage
#		self.texture = _texture
#	func attack(space_state: Physics2DDirectSpaceState):
#		pass
#
#
#class Sword extends Weapon:
#	var radius
#	var angle
#	func attack(space_state : Physics2DDirectSpaceState):
#		var shape = CircleShape2D.new()
#		var args = Physics2DShapeQueryParameters.new()
#		args.set_shape(shape)
#		shape.radius = radius
#		space_state.intersect_shape(args)
#		var space_state = get_world_2d()
#
#
#class Consumable:
#	pass
#
#
#class Relic:
#	var effects = {
#		"buff" : {
#
#		}
#	}
#
#
#class Spawner extends Item:
#	var enemy_id
#	var squad_amount

