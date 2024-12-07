extends State


class_name EntityHurtState


@export var hurt_timer: Timer
var attacker

# Função que é chamada ao entrar no estado
func enter(args: Dictionary = {}) -> void:
	print("hurt state")
	if "target" in args:
		attacker = args["target"]
	handle_anim()
	entity.can_move = false
	hurt_timer.start()
	
# Função chamada enquanto o estado está ativo
func update(delta: float) -> void:
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
	if entity.hp <= 0:
		manager.change_state("DeathState")
	
		
