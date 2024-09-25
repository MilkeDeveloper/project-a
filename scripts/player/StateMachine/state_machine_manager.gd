extends Node

class_name StateMachineManager

var current_state: State = null
var states: Dictionary = {}

func _ready() -> void:
	# Inicializa todos os estados como filhos
	for child in get_parent().get_node("State").get_children():
		if child is State:
			states[child.name] = child

	# Inicia o estado inicial (por exemplo, Idle)
	change_state("IdleState")
	print(current_state)

func change_state(new_state_name: String, args: Dictionary = {}) -> void:
	if current_state != null:
		current_state.exit()

	if new_state_name in states:
		current_state = states[new_state_name]
		current_state.enter(args)

func _process(delta: float) -> void:
	if current_state != null:
		current_state.update(delta)

func _input(event: InputEvent) -> void:
	if current_state != null:
		current_state.handle_input(event)
