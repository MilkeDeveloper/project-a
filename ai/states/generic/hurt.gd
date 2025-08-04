extends StateData

class_name Hurt

func _enter() -> void:
	target = get_tree().get_nodes_in_group("player").pop_front()
	action.start_hurt(target)
	hurt_timer.start()

func _update(delta: float) -> void:
	if hurt_timer.time_left <= 0:
		dispatch(&"start_attack")
	if actor.hp <= 0:
		dispatch(&"die")
