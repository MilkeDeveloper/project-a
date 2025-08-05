extends State

class_name AttackState

func enter(args: Dictionary = {}) -> void:
	if GLobals.target and attack_timer.timeout:
		if GLobals.target.hp > 0:
			entity.find_child("basic_attack").ranged_basic_attack(GLobals.target)
			
	entity.can_move = false
	
	if not GLobals.target:
		animation.play("swordAttack1_" + direction_tracker.get_direction())
		
	if GLobals.target and entity.global_position.distance_to(GLobals.target.global_position) <= entity.get_node("basic_attack").attack_range:
		animation.play("swordAttack1_" + direction_tracker.get_action_direction(GLobals.target.global_position))
	else: 
		animation.play("swordAttack1_" + direction_tracker.get_direction())
		
	await get_tree().create_timer(0.3).timeout
	entity.can_move = true
	#navigation.set_process(true)
	attack_timer.start()
	transit_state()

# Função chamada enquanto o estado está ativo
func update(delta: float) -> void:
	handle_anim()
	#transit_state()
	
		
	

# Função chamada quando saímos do estado
func exit() -> void:
	animation.stop()

# Método opcional para transições rápidas entre estados
func handle_input(event: InputEvent) -> void:
	pass

func handle_anim():
	
	pass
	
func transit_state():
	await animation.animation_finished
	manager.change_state("IdleState")
