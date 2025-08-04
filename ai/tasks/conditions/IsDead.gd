@tool
extends BTCondition

## Verifica se a vida do agente chegou a 0 ou menos.

@export var target_var: StringName = &"target" 
@export var hp_var: StringName = &"hp"


func _generate_name() -> String:
	return "IsDead (%s)" % LimboUtility.decorate_var(hp_var)

func _tick(_delta: float) -> Status:
	var target: Node = blackboard.get_var(target_var, null)
	var hp = target.hp
	return SUCCESS if hp <= 0 else FAILURE
