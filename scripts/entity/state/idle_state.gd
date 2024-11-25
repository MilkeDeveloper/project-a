extends State

class_name EntityIdleState

# Função que é chamada ao entrar no estado
func enter(args: Dictionary = {}) -> void:
	print("inimigo no idle")
	
# Função chamada enquanto o estado está ativo
func update(delta: float) -> void:
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
	if entity.velocity != Vector2.ZERO:
		manager.change_state("PatrolState")
