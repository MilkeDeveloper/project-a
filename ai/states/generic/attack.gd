extends StateData

class_name Attack

var attack_range: float

func _enter() -> void:
	target = get_tree().get_nodes_in_group("player").pop_front()
	
	attack_range = actor.data.attack_range * actor.data.attack_range
	min_squared_distance = min_distance * min_distance
	actor.can_move = false
	start_attack()
	
	
	
func _update(delta: float) -> void:
	if blackboard.get_var("action_active") == false and not action.in_range(target, min_squared_distance, attack_range):
		if animation.animation_finished and actor.can_move:
			dispatch(&"chasing")
	
	#var offset = Vector2(randf_range(-50, 50), randf_range(-50, 50))
	#navigation.set_destination(actor.global_position + offset)
	
func start_attack():
	var _attacker = get_tree().get_nodes_in_group("player").pop_front()
	await handle_attack_anim(_attacker)
	#entity_action.fire_projectile(_attacker)
	#animation.play("attack_" + direction.get_action_direction(_attacker.global_position))

func handle_attack_anim(attacker: Node):
	if attacker != null:
		if attacker.global_position.x < actor.global_position.x and attacker.global_position.y < actor.global_position.y:
			animation.play("attack_up")
			await animation.animation_finished
		elif attacker.global_position.x > actor.global_position.x and attacker.global_position.y < actor.global_position.y:
			animation.play("attack_up_2")
			await animation.animation_finished
		elif attacker.global_position.x < actor.global_position.x and attacker.global_position.y > actor.global_position.y:
			animation.play("attack_down")
			await animation.animation_finished
		elif attacker.global_position.x > actor.global_position.x and attacker.global_position.y > actor.global_position.y:
			animation.play("attack_down_2")
			
			await animation.animation_finished
			
		animation.play("idle_" + direction.get_action_direction(attacker.global_position))
		actor.can_move = true
