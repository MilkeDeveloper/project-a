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
	if entity.global_position.distance_to(_attacker.global_position) < entity.attack_range:
		manager.change_state("AttackState", {"target": _attacker})
	else:
		chase_attacker(_attacker)
		

func chase_attacker(attaker: CharacterBody2D):
	if not Combat.is_attacking :
		navigation.set_destination(attaker.global_position)
		
		
