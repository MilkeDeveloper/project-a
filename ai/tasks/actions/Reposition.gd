@tool
extends BTAction

class_name RepositionAction

@export var offset: float = 100.0
@export var navigation_var: StringName = &"navigation"
@export var actor_var: StringName = &"actor"

func _generate_name() -> String:
	return "Reposition at ➜ random X, Y - value: (%.1f)" % offset
	
func _enter() -> void:
	var actor: Node = blackboard.get_var(actor_var)
	var navigation: Node = actor.get_node("navigation")
	var deviation_trashhold = Vector2(randf_range(-offset, offset), randf_range(-offset, offset))
	navigation.set_destination(actor.global_position + deviation_trashhold, actor.SPEED)

func _tick(delta: float) -> Status:
	var actor: Node = blackboard.get_var(actor_var)
	var navigation: Node = actor.get_node("navigation")
	
	if not is_instance_valid(navigation):
		return FAILURE
	
	return SUCCESS
