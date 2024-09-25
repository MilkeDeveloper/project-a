extends State

class_name IdleState

func enter(args: Dictionary = {}) -> void:
	print(direction_tracker.get_direction())
	
# Função chamada enquanto o estado está ativo
func update(delta: float) -> void:
	if player.velocity != Vector2.ZERO:
		manager.change_state("RunState", {})
	elif player.velocity != Vector2.ZERO and dash_component.is_dashing:
		manager.change_state("DashState", {})
	
	handle_anim()
# Função chamada quando saímos do estado
func exit() -> void:
	animation.stop()

# Método opcional para transições rápidas entre estados
func handle_input(event: InputEvent) -> void:
	pass

func handle_anim():
	animation.play("idle_" + direction_tracker.get_direction())
