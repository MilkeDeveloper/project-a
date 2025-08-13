@tool
extends BTAction

@export var max_dash_distance := 300.0

func _generate_name() -> String:
	return "MarkTargetAtDistance ➜ Distance (%s)" % LimboUtility.decorate_var(str(max_dash_distance))

func _tick(delta: float) -> Status:
	var actor = blackboard.get_var(&"node")
	var target = blackboard.get_var(&"target")
	if not actor or not target:
		return FAILURE

	var dir = (target.global_position - actor.global_position).normalized()
	var dash_point = actor.global_position + dir * max_dash_distance

	blackboard.set_var(&"locked_target_pos", dash_point)
	return SUCCESS
