tool
extends Area2D

var value: float = 0.0
export(NodePath) var path_to_progress_bar
onready var progress_bar: TextureProgress = get_node(path_to_progress_bar)
export(float) var max_points = 10.0
export(Color) var roof_color = Color.red
var points: float
var modulus: int = 0

func interact(delta: float):
	value += delta

func _physics_process(delta):
	$icon.modulate = roof_color
	if !Engine.editor_hint:
		points = value / 100.0 * max_points
		var player_check = overlaps_body(Global.player)
		$VBoxContainer.visible = player_check
		if $CoolDown.is_stopped():
			$VBoxContainer/CenterContainer2/CoolDownText.text = ""
			if Input.is_action_pressed("interact") and player_check:
				value += delta * 100 / 5.0
			if value > 100.0:
				$CoolDown.start()
		else:
			$VBoxContainer/CenterContainer2/CoolDownText.text = str(int($CoolDown.time_left) + 1)
		progress_bar.value = int(value)

func _on_CoolDown_timeout():
	value = 0.0
	modulus += 1
