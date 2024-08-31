extends Node2D


@export var node: CharacterBody2D
@export var _anim_tree: AnimationTree

var state_machine: LimboHSM
var updated_dir: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine_initialize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_blend_position()

# inicia a StateMachine
func state_machine_initialize():
	state_machine = LimboHSM.new()
	add_child(state_machine)
	
	var idle_state = LimboState.new().named("idle").call_on_enter(idle_start).call_on_update(idle_update)
	var run_state = LimboState.new().named("run").call_on_enter(run_start).call_on_update(run_update)
	
	# Adiciona os estados ná na árvore de estádos da Limbo AI
	state_machine.add_child(idle_state)
	state_machine.add_child(run_state)
	
	# Estado inicial quando a state machine é inicializada
	state_machine.initial_state = idle_state
	
	# Transição entre os estados
	state_machine.add_transition(idle_state, run_state, &"to_run")
	state_machine.add_transition(state_machine.ANYSTATE, idle_state, &"to_idle")
	
	state_machine.initialize(self)
	state_machine.set_active(true)

# Define a animação para idle
func idle_start():
	set_idle(true)

# Atualiza o estado de idle
func idle_update(delta: float):
	if node.velocity != Vector2.ZERO:
		state_machine.dispatch(&"to_run")

# Define a animação para run
func run_start():
	set_running(true)

# Atualiza o estado de run
func run_update(delta: float):
	if node.velocity == Vector2.ZERO:
		state_machine.dispatch(&"to_idle")

# Checa as condições e muda para animação de run
func set_running(value: bool):
	_anim_tree["parameters/conditions/is_running"] = value
	_anim_tree["parameters/conditions/idle"] = not value

# Checa as condições e muda para animação de run
func set_idle(value: bool):
	_anim_tree["parameters/conditions/idle"] = value
	_anim_tree["parameters/conditions/is_running"] = not value

# Atualiza a direção em que o node está olhando
func update_blend_position():
	updated_dir = node.global_position.direction_to(node.get_node("navigation").get_next_path_position())
	_anim_tree["parameters/idle/direction/blend_position"] = updated_dir
	_anim_tree["parameters/run/directions/blend_position"] = updated_dir
