extends BTAction

@export var actor: StringName = &"node"

func _tick(delta: float) -> Status:
	var _actor = blackboard.get_var(actor)
	_actor.data.speed = blackboard.get_var(&"_speed")
	
	return SUCCESS
	
