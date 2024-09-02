extends CharacterBody2D

class_name Entity

@export var _name: String
@export var SPEED = 300.0
@export var hp: int
@export var level: int

@onready var hud_entity: Control = $hud_entity

var mouse_over: bool = false
var targeted: bool = false

func _ready() -> void:
	# inicia a função que define o movimento aleatório
	hud_entity.hide()

func _process(delta: float) -> void:
	pass
