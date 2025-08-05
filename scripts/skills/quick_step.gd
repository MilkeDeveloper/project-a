extends SkillBase

@export var node: CharacterBody2D

@export var dash_distance: float = 100
@export var dash_speed: float = 800
@export var dash_modifier: float
@export var ghost_effect:  PackedScene
@export var node_texture:  Sprite2D
@export var animation_component:  Node2D


var is_dashing: bool = false
var ghost_instance
var ghost
var final_dash_speed: float = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func use_skill(_player, skill_damage, _cooldown, target, _cast_time = null):
	node = _player
	node_texture = node.get_node("sprite")
	activate_dash()

func activate_dash():
	node.get_node("dash_component").is_dashing = true
	var target_position = (get_global_mouse_position() - node.global_position).normalized()
	target_position = node.global_position + (target_position * dash_distance)
	set_dash_speed()
	node.get_node("navigation").set_destination(target_position, node.get_node("dash_component").final_dash_speed)
	
	node.get_node("dash_component").dash()

func set_dash_speed():
	node.get_node("dash_component").final_dash_speed = dash_speed * dash_modifier
	
