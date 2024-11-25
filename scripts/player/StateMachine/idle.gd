extends State

class_name IdleState

func enter(args: Dictionary = {}) -> void:
	print(direction_tracker.get_direction())
	
# Função chamada enquanto o estado está ativo
func update(delta: float) -> void:
	handle_anim()
	transit_state()
	
# Função chamada quando saímos do estado
func exit() -> void:
	animation.stop()

# Método opcional para transições rápidas entre estados
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		is_jumping = true

func handle_anim():
	animation.play("idle_" + direction_tracker.get_direction())

func transit_state():
	if entity.velocity != Vector2.ZERO:
		manager.change_state("RunState", {})
	elif entity.velocity != Vector2.ZERO and dash_component.is_dashing:
		manager.change_state("DashState", {})
	elif entity.velocity == Vector2.ZERO and is_jumping == true:
			manager.change_state("JumpState", {})
			is_jumping = false
	elif entity.velocity == Vector2.ZERO and GLobals.spinning or entity.velocity != Vector2.ZERO and GLobals.spinning:
			manager.change_state("SpinningState", {})
