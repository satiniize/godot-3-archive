extends Area2D

var value: float = 0.0
export(NodePath) var path_to_progress_bar
onready var progress_bar: TextureProgress = get_node(path_to_progress_bar)

func _physics_process(delta):
	var player_check = overlaps_body(Global.player)
	$VBoxContainer.visible = player_check
	if $CoolDown.is_stopped():
		$VBoxContainer/CenterContainer2/CoolDownLabel.text = ""
		if Input.is_action_pressed("interact") and player_check:
			value += delta * 100 / 5.0
		else:
			value = 0.0
		if value >= 100.0:
			Global.player.health += 1
			$CoolDown.start()
	else:
		$VBoxContainer/CenterContainer2/CoolDownLabel.text = str(int($CoolDown.time_left) + 1)
	progress_bar.value = int(value)

func _on_CoolDown_timeout():
	value = 0.0
