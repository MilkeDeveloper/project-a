extends State

class_name SpinningState

func enter(args: Dictionary = {}) -> void:
	pass
	entity.get_node("sprite2").show()

# Função chamada enquanto o estado está ativo
func update(delta: float) -> void:
	handle_anim()

# Função chamada quando saímos do estado
func exit() -> void:
	pass

# Método opcional para transições rápidas entre estados
func handle_input(event: InputEvent) -> void:
	pass

func handle_anim():
	if GLobals.spinning == true:
		animation.play("crossbow_spin")
	else:
		entity.get_node("sprite2").hide()
		entity.get_node("sprite").show()
		if entity.velocity == Vector2.ZERO and not GLobals.spinning:
			manager.change_state("IdleState", {})
		elif entity.velocity != Vector2.ZERO and not GLobals.spinning:
			manager.change_state("RunState", {})
	
func transit_state():
	pass
