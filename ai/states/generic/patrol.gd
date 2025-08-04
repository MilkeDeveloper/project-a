extends StateData

class_name Patrol

func _enter() -> void:
	target = get_tree().get_nodes_in_group("player").pop_front()
	action.start_patrol()
	
	min_squared_distance = min_distance * min_distance
	max_squared_distance = max_distance * max_distance
	
	#print("Distância ao player (squared): ", actor.global_position.distance_squared_to(target.global_position))
	
func _update(delta: float) -> void:
	animation.play("idle_" + direction.get_action_direction(movement_node.new_position))
	print("new_position: ", movement_node.new_position)
	if action.in_range(target, min_squared_distance, max_squared_distance):
		dispatch(&"chasing")
		
	if actor.velocity == Vector2.ZERO:
		dispatch(&"awaitng")
