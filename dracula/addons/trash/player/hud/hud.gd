extends CanvasLayer

var weapon_name = ""
var clip_ammo = 0
var reserve_ammo = 0
var weapon_image: Texture
var energy = 0.0
onready var shop_menu = $ShopMenu
	
#maybe have 3 types of eery armor part? and have them upgradable
#one for every playstyle or that makes sense	

#Legs
	#High Movement = Offensive Play
	#Or Low Knockback = Defensive Play
	
#Arms
	#Lower Recoil and Spread
	
#Torso
	#Increased Health
	#or

#Head

#func _ready():
#	var popupmenu = $PopupMenu
#	var submenu = PopupMenu.new()
#	submenu.name = "submenu"
#	submenu.add_item("item 1")
#	submenu.add_item("item 2")
#	popupmenu.add_child(submenu)
#	popupmenu.add_submenu_item("submenu", "submenu")
	
#head stats = zoom in distance
#body = health
#arm = recoil and spread
#leg = movement speed
export(ButtonGroup) var pause_buttongroup
#export(ButtonGroup) var primary_buttongroup
#export(ButtonGroup) var secondary_buttongroup
#export(ButtonGroup) var melee_buttongroup
export(ButtonGroup) var weapon_group
export(String, FILE) var game_items_path

var weapon_data
var primary_weapon_list = {}
var secondary_weapon_list = {}
var melee_weapon_list = {}
var bought_items = []
var equipped_items = {}
var weapon_buttons = [
	{},
	{},
	{},
]

signal buy_item(item_id)
#implement some item abilities like tf2 power canteen

onready var shop_item_list = $ShopMenu/HSplitContainer/VBoxContainer/ItemList
var game_items_data
#var directories = {
#	"primary" : {
#		"bullet" : {
#
#		},
#		"laser" : {
#
#		}
#	},
#	"secondary" : {
#		"bullet" : {
#
#		},
#		"laser" : {
#
#		}
#	},
#	"melee" : {
#		"knife" : {
#
#		},
#		"longsword" : {
#
#		}
#	}
#}

var menu = {
	"Weapons" : {
		"Primary" : {
			"LoCostRifle" : {
				"behavior" : "purchase",
				"item_id" : "lcr",
				"disabled" : true
			},
			"Estage" : {
				"behavior" : "purchase",
				"item_id" : "estage",
				"disabled" : true
			},
			"Weld Gun" : {
				"behavior" : "purchase",
				"item_id" : "repairgun",
				"disabled" : true
			}
		},
		"Secondary" : {
			"ConvenienceHandGun" : {
				"behavior" : "purchase",
				"item_id" : "glock18",
				"disabled" : true
			},
			"Nage" : {
				"behavior" : "purchase",
				"item_id" : "ghost",
				"disabled" : true
			},
		},
		"Melee" : {
			"HighMobilityHandKnife" : {
				"behavior" : "purchase",
				"item_id" : "golok",
				"disabled" : true
			},
			"Katana" : {
				"behavior" : "purchase",
				"item_id" : "katana",
				"disabled" : true
			},
		},
	},
	"Upgrades" : {
		"offense" : false,
		"defense" : false,
		"agility" : false
	},
	"Items" : {
		"offense" : false,
		"defense" : false,
		"agility" : false
	}
}

#var menu2 = {
#	"weapons" : {
#		"primary" : {
#			"LoCostRifle" : {
#				"behavior" : "purchase",
#				"item_id" : "lcr",
#				"disabled" : true
#			},
#			"Estage" : {
#				"behavior" : "purchase",
#				"item_id" : "estage",
#				"disabled" : true
#			},
#		},
#		"secondary" : {
#			"ConvenienceHandGun" : false,
#			"Nage" : true
#		},
#		"melee" : {
#			"HighMobilityHandKnife" : false,
#			"Katana" : true
#		}
#	},
#	"upgrades" : {
#		"offense" : false,
#		"defense" : false,
#		"agility" : false
#	},
#	"items" : {
#		"offense" : false,
#		"defense" : false,
#		"agility" : false
#	}
#}

var item_list
export(Texture) var placeholder_itemicon
func _ready():
	var game_items_file = File.new()
	game_items_file.open(game_items_path, File.READ)
	game_items_data = JSON.parse(game_items_file.get_as_text()).result
#	print("a")
	weapon_group.connect("pressed", self, "_shop_menu_pressed")
#	setup_shop_menu()
	update_directories()

#func _shop_menu_pressed(button):
#	if button.text == "up": #should probably change this
#		current_path.remove(len(current_path) - 1)
#	elif len(current_path) < 2:
#		current_path.append(button.text)
#	else:
#		var weapon_buy_path = current_path.duplicate()
#		weapon_buy_path.append(button.text)
#		var button_data = menu.duplicate()
#		for path in weapon_buy_path:
#			button_data = button_data[path]
#		emit_signal("buy_item", button_data["item_id"])
#		print(button_data["item_id"])
#	update_directories()
		

var current_path = []

func update_directories():
	shop_item_list.clear()
	var menu_data = menu
	for path in current_path:
		menu_data = menu_data[path]
	var count = 0
	for item in menu_data.keys():
		shop_item_list.add_item(item, placeholder_itemicon)
#		print(equipped_items)
		if len(current_path) > 1:
			var item_path = current_path.duplicate(true)
			item_path.append(item)
			var item_data = menu.duplicate(true)
			var all_bought_items = []
			for slot in bought_items:
				all_bought_items.append_array(slot)
			print(all_bought_items)
			for path in item_path:
				item_data = item_data[path]
			shop_item_list.set_item_text(count, item + " (" + str(game_items_data["weapons"][item_data["item_id"]]["price"]) + " Tokens)")
			if item_data["item_id"] in equipped_items:
				shop_item_list.set_item_custom_bg_color(count, Color("0a2474"))
			elif item_data["item_id"] in all_bought_items:
				shop_item_list.set_item_custom_bg_color(count, Color("006e00"))
		count += 1
#	var vbox = shop_menu.get_node("HSplitContainer/VBoxContainer/VBoxContainer")
#		if count == 0:
#			vbox.get_children()[count].text = "up"
#		if count < len(menu_data) + 1:
#			vbox.get_children()[count].text = menu_data.keys()[count - 1]
#			vbox.get_children()[count].disabled = false
#		else:
#			vbox.get_children()[count].text = "-"
#			vbox.get_children()[count].disabled = true
func _process(delta):
#	update_shop_menu()
#	print(pause_buttongroup.get_pressed_button())
	$Ping.text = str(Network.current_ping)
	$Label.text = str(Performance.get_monitor(Performance.TIME_FPS))
	if Input.is_action_just_pressed("hud_chat"):
		$ChatPopup.popup()
	if $ChatPopup.visible or $PausePopup.visible or $ShopMenu.visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#	if Input.is_action_just_pressed("hud_buy"):
#		$Popup2.visible = not $Popup2.visible
	if Input.is_action_just_pressed("ui_cancel"):
		$PausePopup.popup()
	if Input.is_action_just_pressed("hud_buy"):
#		$Popup2.popup()
		$ShopMenu.popup()
#		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_just_pressed("hud_scoreboard"):
		$ScoreboardPopup.popup()
	if Input.is_action_just_released("hud_scoreboard"):
		$ScoreboardPopup.hide()
	
	$PanelContainer2/MarginContainer/VBoxContainer/HBoxContainer2/Label.text = weapon_name
	$PanelContainer2/MarginContainer/VBoxContainer/HBoxContainer/Label2.text = str(clip_ammo) + "/" + str(reserve_ammo)
	$PanelContainer2/MarginContainer/VBoxContainer/HBoxContainer/TextureRect.texture = weapon_image
	$PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/ProgressBar.value = energy
	
	$PanelContainer3/HBoxContainer/Label2.text = str(round(get_tree().current_scene.get_node("RoundTimer").time_left))
	$PanelContainer3/HBoxContainer/HealthRed.text = " " + str(get_tree().current_scene.health_red) + " "
	$PanelContainer3/HBoxContainer/HealthBlue.text = " " + str(get_tree().current_scene.health_blue) + " "
	



func _on_ItemList_item_activated(index):
#	print("boo")
#	if button.text == "up": #should probably change this
#		current_path.remove(len(current_path) - 1)
	var selected_path = menu.duplicate()
	for path in current_path:
		selected_path = selected_path[path]
#	var new_path = selected_path[selected_path.keys()[index]]
	var new_path = selected_path.keys()[index]
	if len(current_path) < 2:
		current_path.append(new_path)
	else:
#	if len(current_path) > 1:
		var weapon_buy_path = current_path.duplicate()
		weapon_buy_path.append(new_path)
		var item_data = menu.duplicate()
		for path in weapon_buy_path:
			item_data = item_data[path]
		emit_signal("buy_item", item_data["item_id"])
#		print(item_data["item_id"])
	update_directories()


	
	
	
#func setup_shop_menu():
#	shop_menu.get_node("HSplitContainer/VBoxContainer/Category")
#	var slot = 0
#	for weapon_slot in weapon_data:
#		for weapon_id in weapon_slot.keys():
#			var button = Button.new()
#			button.text = weapon_data[slot][weapon_id]["name"]
#			button.group = weapon_buttongroup
#			button.set_h_size_flags(Control.SIZE_EXPAND_FILL)
#			button.icon = placeholder_itemicon
#			weapon_buttons[slot][button] = weapon_id
#		slot += 1 
#	print(weapon_buttons)
	
	
	
	
#	for primary in weapon_data[0]:
#		var button = Button.new()
#		button.group = primary_buttongroup
#		primary_weapon_list[button.get_instance_id()] = primary
#	for secondary in weapon_data[1]:
#		var button = Button.new()
#		button.group = secondary_buttongroup
#		secondary_weapon_list[button.get_instance_id()] = secondary
#	for melee in weapon_data[2]:
#		var button = Button.new()
#		button.group = melee_buttongroup
#		melee_weapon_list[button.get_instance_id()] = melee

#func update_shop_menu():
#	if shop_menu.get_node("HSplitContainer/VBoxContainer/Category").selected == 0:
#		var vbox = shop_menu.get_node("HSplitContainer/VBoxContainer/ScrollContainer/VBoxContainer")
#		var button_list = weapon_buttons[shop_menu.get_node("HSplitContainer/VBoxContainer/SubCategory").selected]
#
#		for child in vbox.get_children():
#			print(vbox.get_children())
##			child.queue_free()
#			if not child in button_list.keys():
#				remove_child(child)
#		for button in button_list.keys():
#			print(button_list)
#			if not button in vbox.get_children():
#				vbox.add_child(button)
				
				
				
				
				
#			if not child in button_list.keys():
#				pass
			
#		match shop_menu.get_node("HSplitContainer/VBoxContainer/SubCategory").selected:
#			0:
#				for i in primary_weapon_list:
#					pass
##					if vbox
#			1:
#				for i in secondary_weapon_list:
#					pass
#			2:
#				for i in melee_buttongroup:
#					pass


#	$HBoxContainer/MarginContainer/VBoxContainer/ProgressBar.value += 1
#	$HBoxContainer/MarginContainer/VBoxContainer/ProgressBar.value = fmod($HBoxContainer/MarginContainer/VBoxContainer/ProgressBar.value, 100.0)
#	$HBoxContainer/CenterContainer2/TextureProgress.value += 1
#	$HBoxContainer/CenterContainer2/TextureProgress.value = fmod($HBoxContainer/CenterContainer2/TextureProgress.value, 100.0)
#	$HBoxContainer/CenterContainer2/TextureProgress2.value += 2
#	$HBoxContainer/CenterContainer2/TextureProgress2.value = fmod($HBoxContainer/CenterContainer2/TextureProgress2.value, 100.0)
#shop_data

# Name = Stage 1 Head Unit
# Desc = Mandatory something something i cant be bothered to write this
# Price = 0 (Tokens)
		# harvest tokens from something like the jungle
# Quality = 1
		# 0 = stock
		# 1 = Stage 1
		# etc
# Icon = "res://something.jpeg" probably

#	if weapon_group.get_pressed_button() != null:
#		if weapon_group.get_pressed_button().text == "up": #should probably change this
#			current_path.remove(len(current_path) - 1)
#		else:
#			current_path.append(weapon_group.get_pressed_button().text)
#	print(menu_data.keys())
#	for path in menu_data.keys():
#		pass
#	print(shop_menu)


func _on_Up_pressed():
	current_path.remove(len(current_path) - 1)
	update_directories()
