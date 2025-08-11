extends StateData

class_name Hurt

func _enter() -> void:
	target = get_tree().get_nodes_in_group("player").pop_front()
	action.start_hurt(target)
	hurt_timer.start()
	actor.can_move = false
	#animation.play("hurt_" + direction.get_action_direction(target.global_position))

func _update(delta: float) -> void:
	if actor.hp <= 0:
		dispatch(&"die")


func _on_hurt_timer_timeout() -> void:
	actor.can_move = true
	dispatch(&"chasing")
