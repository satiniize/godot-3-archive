extends Spatial

onready var interactables = get_node("interactebles")
onready var tables: Array = interactables.get_node("tables").get_children()
onready var toilets: Array = interactables.get_node("toilets").get_children()
onready var spills: Spatial = get_node("spills")
onready var spill_area: Array = get_node("spill_area").get_children()
onready var camera: Camera = get_node("Camera")
