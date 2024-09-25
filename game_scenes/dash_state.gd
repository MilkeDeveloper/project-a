extends State

class_name DashState

# Função que é chamada ao entrar no estado
func enter(args: Dictionary = {}) -> void:
	pass
	print("dashing")

# Função chamada enquanto o estado está ativo
func update(delta: float) -> void:
	handle_anim()
	if player.velocity == Vector2.ZERO:
		manager.change_state("IdleState", {})
	elif player.velocity != Vector2.ZERO and not dash_component.is_dashing:
		manager.change_state("RunState", {})
	
	
# Função chamada quando saímos do estado
func exit() -> void:
	pass

# Método opcional para transições rápidas entre estados
func handle_input(event: InputEvent) -> void:
	pass

func handle_anim():
	animation.play("dash_" + direction_tracker.get_direction())
	
