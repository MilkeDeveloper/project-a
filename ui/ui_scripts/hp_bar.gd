extends Control

@export var node:  Node2D
@onready var hp_bar: TextureProgressBar = $hp_bar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hp_bar.value = node.hp


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
