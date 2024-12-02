extends State


class_name EntityDeathState

# Função que é chamada ao entrar no estado
func enter(args: Dictionary = {}) -> void:
	print("death state")
	Combat.is_attacking = false
	handle_anim()
	attack_timer.stop()
	
# Função chamada enquanto o estado está ativo
func update(delta: float) -> void:
	
	transit_state()

# Função chamada quando saímos do estado
func exit() -> void:
	pass

# Função que lida com as animações do estado atual
func handle_anim():
	animation.play("death_" + direction_tracker.get_direction())
	
# Função para transitar para outros estados
func transit_state():
	pass
