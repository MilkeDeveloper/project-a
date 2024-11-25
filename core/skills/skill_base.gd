extends Node2D

class_name SkillBase

@export var Projectile: PackedScene
@export var animation: AnimationPlayer
@export var selector: Sprite2D
@export var projectile_config: ProjectileData 

var _target : Node
var cast_time: float
var cooldown : float
var damage : int
var cast_skill : bool = false
var is_charging: bool = false
var mouse_position : Vector2
var player: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func use_skill(_player, skill_damage, _cooldown, target, _cast_time = null):
	player = _player
	
func cancel_skill():
	pass

func _input(event: InputEvent) -> void:
	pass
