extends LimboHSM

class_name StateMachine

@export var states : Dictionary[StringName, BTState]
@export var entity: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_states()
	initialize(entity)
	set_initial_state(states["idle"])
	set_active(true)

func _setup_states():
	add_transition(states["idle"], states["patrol"], &"patrolling")
	add_transition(states["patrol"], states["idle"], &"awaiting")
	add_transition(states["chase"], states["patrol"], &"back_to_patrol")
	add_transition(ANYSTATE, states["attack"], &"start_attack")
	add_transition(ANYSTATE, states["chase"], &"chasing")
	add_transition(states["hurt"], states["idle"], &"back_to_idle")
	add_transition(ANYSTATE, states["hurt"], &"hurted")
	add_transition(ANYSTATE, states["death"], &"die")
	add_transition(states["hiden"], states["attack"], &"ambush")
	add_transition(states["attack"], states["jump_back"], &"special_attack1")
