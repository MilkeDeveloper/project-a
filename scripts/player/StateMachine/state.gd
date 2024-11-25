extends Node

class_name State

@export var entity: CharacterBody2D
@export var anim_tree: AnimationTree
@export var direction_tracker: DirectionTracker
@export var animation: AnimationPlayer
@export var attack_timer: Timer
@export var navigation: NavigationAgent2D

# Referência ao State Machine Manager
@export var manager: StateMachineManager
@export var dash_component: Node2D

var is_jumping: bool = false
var original_speed: float
var can_attack: bool = true

# Função que é chamada ao entrar no estado
func enter(args: Dictionary = {}) -> void:
	pass

# Função chamada enquanto o estado está ativo
func update(delta: float) -> void:
	pass

# Função chamada quando saímos do estado
func exit() -> void:
	pass

# Método opcional para transições rápidas entre estados
func handle_input(event: InputEvent) -> void:
	pass

func handle_anim():
	pass
	
func transit_state():
	pass
