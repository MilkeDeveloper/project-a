@tool
extends BTAction
## Stores the first node in the [member group] on the blackboard, returning [code]SUCCESS[/code]. [br]
## Returns [code]FAILURE[/code] if the group contains 0 nodes.


## Blackboard variable in which the task will store the acquired node.
@export var entity: StringName = &"node"


func _generate_name() -> String:
	return "GetNode  ➜ (%s)" % LimboUtility.decorate_var(entity)
		

func _tick(_delta: float) -> Status:
	var node: Node = agent
	if not node:
		return FAILURE
	blackboard.set_var(entity, node)
	return SUCCESS
