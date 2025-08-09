extends State

class_name AttackState

var time: float = 0.0

func enter(args: Dictionary = {}) -> void:
	if GLobals.target and attack_timer.timeout:
		if GLobals.target.hp > 0:
			entity.find_child("basic_attack").ranged_basic_attack(GLobals.target)
	entity.is_attacking = true
	hit_box.monitoring = true
	entity.can_move = false

	handle_anim()
	
	
	
	#navigation.set_process(true)
	attack_timer.start()

# Função chamada enquanto o estado está ativo
func update(delta: float) -> void:
	
	#transit_state()
	time += delta
	if time >= 0.2:
		end_attack()
	

# Função chamada quando saímos do estado
func exit() -> void:
	hit_box.monitoring = false
	

# Método opcional para transições rápidas entre estados
func handle_input(event: InputEvent) -> void:
	pass

func handle_anim():
	if not GLobals.target:
		animation.play("swordAttack1_" + direction_tracker.get_action_direction(entity.get_global_mouse_position()))
		
	if GLobals.target and entity.global_position.distance_to(GLobals.target.global_position) <= entity.get_node("basic_attack").attack_range:
		animation.play("swordAttack1_" + direction_tracker.get_action_direction(GLobals.target.global_position))
	else: 
		animation.play("swordAttack1_" + direction_tracker.get_direction())

func end_attack():
	time = 0.0
	entity.can_move = true
	entity.is_attacking = false
	transit_state()

func transit_state():
	await animation.animation_finished
	manager.change_state("IdleState")
