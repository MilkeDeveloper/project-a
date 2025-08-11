@tool
extends BTAction

@export var actor_var: StringName = &"node"

func _generate_name() -> String:
	return "HideEntity"
	
func _tick(delta: float) -> Status:
	var actor = blackboard.get_var(actor_var)
	var state = actor.get_node("StateMachine")
	actor.visible = false
	actor.set_collision_layer(0)
	actor.set_collision_mask(0)
	
	state.change_active_state(state.get_node("HidenState"))
	
	return SUCCESS
