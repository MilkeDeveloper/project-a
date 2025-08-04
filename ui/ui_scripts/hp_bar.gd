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
	if node.is_in_group("entity"):
		hp_bar.value = node.hp
		bar.value = node.hp
		hp_bar.max_value = node.max_hp
		bar.max_value = node.max_hp
		level.text = "Lv. " + str(node.level)
		level.show()
		hp_text.text = str(node.hp) + "/" + str(node.max_hp)
		level_hud.text = "Lv. " + str(node.level)
		name_hud.text = node._name
		
	else:
		level.hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update_bars(updated_hp):
	hp_bar.value = updated_hp
	bar.value = updated_hp
	hp_text.text = str(updated_hp) + "/" + str(node.max_hp)
