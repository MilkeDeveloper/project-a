extends Node2D

@export var node : CharacterBody2D
@export var navigation_component : NavigationAgent2D

@export var dash_distance: float = 100
@export var dash_speed: float = 800
@export var dash_modifier: float
@export var ghost_effect:  PackedScene
@export var node_texture:  Sprite2D
@export var animation_component:  Node2D

@onready var ghost_timer: Timer = $ghost_timer

var is_dashing: bool = false
var ghost_instance
var ghost
var final_dash_speed: float = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func dash():
	is_dashing = true
	var target_position = (get_global_mouse_position() - node.global_position).normalized()
	target_position = node.global_position + (target_position * dash_distance)
	set_dash_speed()
	_dash_effect()
	navigation_component.set_destination(target_position)

func set_dash_speed():
	final_dash_speed = dash_speed * dash_modifier

func set_dash_anim():
	animation_component.state_machine.dispatch(&"to_dash")
	
	
func end_dash():
	node.SPEED = 650
	is_dashing = false
	ghost_timer.stop()

func _dash_effect():
	ghost_instance = ghost_effect.instantiate()
	node.get_parent().add_child(ghost_instance)
	ghost = ghost_instance.get_node("ghost_sprite")
	ghost.texture = node_texture.texture
	ghost.hframes = node_texture.hframes
	ghost.vframes = node_texture.vframes
	ghost.frame = node_texture.frame
	ghost_instance.global_position = node.global_position
	
	ghost_timer.start()
	
func _on_ghost_timer_timeout() -> void:
	_dash_effect()
