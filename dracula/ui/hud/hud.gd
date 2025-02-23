extends CanvasLayer

export(NodePath) var player_path
onready var player = get_node(player_path)

#0 = shotgun

var variables : Dictionary = {
	"show_fps" : "0",
	"show_pos" : "0",
	"show_vel" : "0"
}

func _ready():
	var str_array : PoolStringArray = variables.keys()
	$Popup/VBoxContainer/ColorRect/RichTextLabel.add_text("available variables:\n" + str_array.join("\n") + "\n")

func _process(delta):
	$VBoxContainer2/HealthBar.value = player.health
	$VBoxContainer2/BatBar.value = player.vamp_charge
	
	if Input.is_action_just_pressed("debug"):
		$Popup.popup()
	
	if variables["show_fps"] == "1":
		$DebugInfo/FPS.show()
		$DebugInfo/FPS.text = "fps : " + str(Performance.get_monitor(Performance.TIME_FPS))
	else:
		$DebugInfo/FPS.hide()
	if variables["show_pos"] == "1":
		var pos = player.global_transform.origin
		$DebugInfo/Pos.show()
		$DebugInfo/Pos.text = "x : " + str(pos.x) + "\n" + "y : " + str(pos.y) + "\n" + "z : " + str(pos.z)
	else:
		$DebugInfo/Pos.hide()
	if variables["show_vel"] == "1":
		var vel = player.velocity.length()
		$DebugInfo/Vel.show()
		$DebugInfo/Vel.text = "vel : " + str(vel)
	else:
		$DebugInfo/Vel.hide()
	$VBoxContainer/Ammo.text = (
		"Shells : " + str(player.ammo[ItemDef.AmmoType.SHELL]) +
		"\nLight : " + str(player.ammo[ItemDef.AmmoType.LIGHT]) +
		"\nGrenades : " + str(player.ammo[ItemDef.AmmoType.GRENADE])
	)

func _on_LineEdit_text_entered(new_text):
	var label = $Popup/VBoxContainer/ColorRect/RichTextLabel
	var array = new_text.split(" ", true, 2)
	if array.size() < 2:
		label.add_text("insufficient arguments\n")
		return
	var variable_name = array[0]
	var value = array[1]
	if not variable_name in variables.keys():
		label.add_text("unknown variable \"" + variable_name + "\"\n")
		return
	variables[variable_name] = value
	label.add_text("variable \"" + variable_name + "\" set to \"" + value + "\"\n")
	$Popup/VBoxContainer/HBoxContainer/LineEdit.clear()
