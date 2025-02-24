extends CanvasLayer

onready var anim = get_node("AnimationPlayer")
onready var stacked_plates = get_node("plates")
onready var progress_bar = get_node("progress/bar")
onready var health = get_node("CenterContainer/health")
onready var points = get_node("points")

func _ready():
	Global.player.hud = self
	
func set_hand_dirty(value: bool):
	$TextureRect.material.set_shader_param("dirty", value)

func _physics_process(delta):
	if Input.is_action_just_pressed("debug"):
		$Popup.popup_centered()
	$fps.text = str(Performance.get_monitor(Performance.TIME_FPS))
	$CenterContainer/health.value = Global.player_health
	set_hand_dirty(Global.player.hand_state == Global.player.DIRTY)
	stacked_plates.meals = Global.player.stored_meals

func check_arrows(type: int):
	match type:
		Interactable.interact_modes.HORIZONTAL:
			anim.play("horizontal")
		Interactable.interact_modes.VERTICAL:
			anim.play("vertical")
		Interactable.interact_modes.CLOCKWISE:
			anim.play("clockwise")
		Interactable.interact_modes.COUNTER_CLOCKWISE:
			anim.play("counter_clockwise")
		Interactable.interact_modes.NONE:
			anim.play("none")
			
func toggle_visibility():
	for i in get_children():
		if i is Control:
			i.visible = !i.visible
