extends State


class_name EntityHurtState

var attacker

# Função que é chamada ao entrar no estado
func enter(args: Dictionary = {}) -> void:
	print("hurt state")
	if "target" in args:
		attacker = args["target"]
	
# Função chamada enquanto o estado está ativo
func update(delta: float) -> void:
	handle_anim()
	transit_state()

# Função chamada quando saímos do estado
func exit() -> void:
	pass

# Função que lida com as animações do estado atual
func handle_anim():
	animation.play("hurt_" + direction_tracker.get_action_direction(attacker.global_position))

# Função para transitar para outros estados
func transit_state():
	await animation.animation_finished
	manager.change_state("ChaseState", {"target": attacker})
	
		
