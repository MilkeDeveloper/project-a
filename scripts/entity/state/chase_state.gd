extends State

class_name EntityChaseState

var _attacker: CharacterBody2D

# Função que é chamada ao entrar no estado
func enter(args: Dictionary = {}) -> void:
	print("chase attacker")
	if "target" in args:
		_attacker = args["target"]

# Função chamada enquanto o estado está ativo
func update(delta: float) -> void:
	if entity.hp > 0:
		chase_attacker(_attacker)
		handle_anim()
		transit_state()
	

# Função chamada quando saímos do estado
func exit() -> void:
	pass

# Função que lida com as animações do estado atual
func handle_anim():
	animation.play("idle_" + direction_tracker.get_direction())

# Função para transitar para outros estados
func transit_state():
	if distance_to_player() < entity.attack_range and distance_to_player() > 0:
		if entity.hp > 0:
			manager.change_state("AttackState", {"target": _attacker})
		else:
			#await get_tree().create_timer(1.5).timeout
			#entity.can_move = true
			#chase_attacker(_attacker)
			manager.change_state("DeathState")
	else:
		chase_attacker(_attacker)

func chase_attacker(attaker: CharacterBody2D):
	if distance_to_player() > entity.attack_range:
		navigation.set_destination(attaker.global_position)
	else:
		navigation.set_destination(entity.global_position)
		
func distance_to_player() -> float:
	return entity.global_position.distance_to(_attacker.global_position)
