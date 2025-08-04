extends StateData

class_name Attack

var attack_range: float

func _enter() -> void:
	target = get_tree().get_nodes_in_group("player").pop_front()
	
	attack_range = actor.attack_range * actor.attack_range
	min_squared_distance = min_distance * min_distance
	
func _update(delta: float) -> void:
	if blackboard.get_var("action_active") == false and not action.in_range(target, min_squared_distance, attack_range):
		dispatch(&"chasing")
	
	#var offset = Vector2(randf_range(-50, 50), randf_range(-50, 50))
	#navigation.set_destination(actor.global_position + offset)
