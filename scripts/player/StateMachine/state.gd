extends Node

class_name State

@export var player: Player
@export var anim_tree: AnimationTree
@export var direction_tracker: DirectionTracker
@export var animation: AnimationPlayer

# Referência ao State Machine Manager
@export var manager: StateMachineManager
@export var dash_component: Node2D

var is_jumping: bool = false
var original_speed: float

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
