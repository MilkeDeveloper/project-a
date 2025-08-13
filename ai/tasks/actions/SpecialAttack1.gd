@tool
extends BTAction

@export var actor: StringName = &"node"


func _tick(delta: float) -> Status:
	var _actor = blackboard.get_var(actor)
	var state = _actor.get_node("StateMachine")
	
	_actor.set_collision_layer(1)
	
	
	state.dispatch(&"special_attack1")


	return SUCCESS
