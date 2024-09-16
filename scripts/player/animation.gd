extends Node2D


@export var node: CharacterBody2D
@export var _anim_tree: AnimationTree
@export var dash_component: Node2D

var state_machine: LimboHSM
var updated_dir: Vector2
var direction_target: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine_initialize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_blend_position(direction_target)

# inicia a StateMachine
func state_machine_initialize():
	state_machine = LimboHSM.new()
	add_child(state_machine)
	
	var idle_state = LimboState.new().named("idle").call_on_enter(idle_start).call_on_update(idle_update)
	var run_state = LimboState.new().named("run").call_on_enter(run_start).call_on_update(run_update)
	var dash_state = LimboState.new().named("dash").call_on_enter(dash_start).call_on_update(dash_update)
	
	# Adiciona os estados ná na árvore de estádos da Limbo AI
	state_machine.add_child(idle_state)
	state_machine.add_child(run_state)
	state_machine.add_child(dash_state)
	
	# Estado inicial quando a state machine é inicializada
	if dash_component != null:
		state_machine.initial_state = idle_state
	
	# Transição entre os estados
	state_machine.add_transition(idle_state, run_state, &"to_run")
	state_machine.add_transition(state_machine.ANYSTATE, idle_state, &"to_idle")
	state_machine.add_transition(state_machine.ANYSTATE, dash_state, &"to_dash")
	
	state_machine.initialize(self)
	state_machine.set_active(true)

# Define a animação para idle
func idle_start():
	set_idle(true)

# Atualiza o estado de idle
func idle_update(delta: float):
	if dash_component != null:
		if node.velocity != Vector2.ZERO and not dash_component.is_dashing:
			state_machine.dispatch(&"to_run")
		elif node.velocity != Vector2.ZERO and dash_component.is_dashing:
			state_machine.dispatch(&"to_dash")
			
# Define a animação para run
func run_start():
	set_running(true)

# Atualiza o estado de run
func run_update(delta: float):
	if dash_component != null:
		if node.velocity == Vector2.ZERO and not dash_component.is_dashing:
			state_machine.dispatch(&"to_idle")
		elif node.velocity != Vector2.ZERO and dash_component.is_dashing:
			state_machine.dispatch(&"to_dash")
			
# Define a animação para dash
func dash_start():
	if dash_component.is_dashing:
		set_dashing(true)

# Atualiza o estado de dash
func dash_update(delta: float):
	if node.velocity == Vector2.ZERO:
		state_machine.dispatch(&"to_idle")

# Checa as condições e muda para animação de dash
func set_dashing(value: bool = false):
	dash_component.is_dashing = value
	_anim_tree["parameters/conditions/is_dashing"] = value
	_anim_tree["parameters/conditions/is_running"] = false
	_anim_tree["parameters/conditions/idle"] = false
	
# Checa as condições e muda para animação de run
func set_running(value: bool):
	_anim_tree["parameters/conditions/is_running"] = value
	_anim_tree["parameters/conditions/idle"] = not value
	if dash_component != null:
		_anim_tree["parameters/conditions/is_dashing"] = not value

# Checa as condições e muda para animação de idle
func set_idle(value: bool):
	_anim_tree["parameters/conditions/idle"] = value
	_anim_tree["parameters/conditions/is_running"] = not value
	if dash_component != null:
		_anim_tree["parameters/conditions/is_dashing"] = not value

# Atualiza a direção em que o node está olhando
func update_blend_position(_target : Vector2):
	direction_target = _target
	updated_dir = node.global_position.direction_to(direction_target)
	_anim_tree["parameters/idle/direction/blend_position"] = updated_dir
	_anim_tree["parameters/run/directions/blend_position"] = updated_dir
	if dash_component != null:
		_anim_tree["parameters/dash/directions2/blend_position"] = updated_dir
