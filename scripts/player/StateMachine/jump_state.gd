extends State

class_name JumpState


# Função que é chamada ao entrar no estado
func enter(args: Dictionary = {}) -> void:
	#animation.play("jump_" + direction_tracker.get_direction())
	print("jump")
	entity.jumping = true
	
	
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
	var current_frame = animation.current_animation_position
	animation.play("jump_" + direction_tracker.get_direction())
	animation.seek(current_frame, true)
	

func transit_state():
	if entity.velocity == Vector2.ZERO:
		manager.change_state("IdleState", {})
	elif entity.velocity != Vector2.ZERO:
		entity.SPEED = (entity.SPEED / 2) + 200
		manager.change_state("RunState", {})
