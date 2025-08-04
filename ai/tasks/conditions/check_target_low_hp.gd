@tool
extends BTCondition
class_name CheckTargetLowHP

@export var threshold: float = 0.3
@export var target_var: StringName = &"target"

func _generate_name() -> String:
	return "Target HP <= %.0f%%" % [threshold * 100.0,
	LimboUtility.decorate_var(target_var)]

func _tick(_delta: float) -> Status:
	var target = blackboard.get_var(target_var, null)
	if target == null or not target.has_method("get_health_percent"):
		return FAILURE

	var hp_percent = target.get_health_percent()
	return SUCCESS if hp_percent <= threshold else FAILURE
