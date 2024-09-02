extends Node2D

@export var node : CharacterBody2D
@export var navigation_component : NavigationAgent2D

@export var dash_distance: float = 100
@export var dash_speed: float = 800
@export var dash_modifier: float

var is_dashing: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func dash():
	is_dashing = true
	var target_position = (get_global_mouse_position() - node.global_position).normalized()
	target_position = node.global_position + (target_position * dash_distance)
	set_dash_speed()
	navigation_component.set_destination(target_position)

func set_dash_speed():
	node.SPEED = dash_speed * dash_modifier
	
func end_dash():
	node.SPEED = 650
	is_dashing = false
