extends StateData

class_name Attack

@export var hit_box: Area2D
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
		hit_box.look_at(attacker.global_position)
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


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_node("take_damage"):
			body.get_node("take_damage").apply_dmg_popup(actor.data.damage, actor, body, "new_default_dmg_3")


func _on_ambush_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_node("take_damage"):
			body.get_node("take_damage").apply_dmg_popup(actor.data.damage * 2, actor, body, "new_default_dmg_3")
