extends Control

@export var node:  Node2D
@onready var hp_bar: TextureProgressBar = $hp_bar
@onready var level: Label = $level
@onready var bar: TextureProgressBar = $HUD_HP/bar
@onready var hp_text: Label = $HUD_HP/bar/hp_text
@onready var level_hud: Label = %level_hud
@onready var name_hud: Label = %name_hud

var nodes: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hp_bar.value = node.hp
	bar.max_value = node.hp
	bar.value = node.hp
	if get_parent().is_in_group("entity"):
		level.text = "Lv. " + str(get_parent().level)
		level.show()
		hp_text.text = str(bar.value) + "/" + str(bar.max_value)
		level_hud.text = "Lv. " + str(get_parent().level)
		name_hud.text = get_parent()._name
		
		
	else:
		level.hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
