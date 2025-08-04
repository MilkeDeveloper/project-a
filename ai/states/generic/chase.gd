extends StateData

class_name Chase
# Called when the node enters the scene tree for the first time.

var attack_range: float

func _enter() -> void:
	target = get_tree().get_nodes_in_group("player").pop_front()
	
	min_squared_distance = min_distance * min_distance
	max_squared_distance = max_distance * max_distance
	attack_range = actor.attack_range * actor.attack_range
	
func _update(delta: float) -> void:
	animation.play("idle_" + direction.get_action_direction(target.global_position))
	if not action.in_range(target, min_squared_distance, max_squared_distance):
		dispatch(&"back_to_patrol")

	elif action.in_range(target, min_squared_distance, attack_range):
		dispatch(&"start_attack")
		
	elif action.in_range(target, min_squared_distance, max_squared_distance): 
		action.start_chase(target)

	
