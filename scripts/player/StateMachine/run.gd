extends State

class_name RunState

func _ready() -> void:
	original_speed = entity.SPEED

func enter(args: Dictionary = {}) -> void:
	await get_tree().create_timer(0.2).timeout
	entity.SPEED = original_speed
	entity.jumping = false
	
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
	if entity.is_in_group("player") and GLobals.target != null:
		animation.play("run_" + entity.get_node("DirectionTracker").get_action_direction(GLobals.target.global_position))
	else:
		animation.play("run_" + direction_tracker.get_direction())

func transit_state():
	if entity.velocity == Vector2.ZERO:
		manager.change_state("IdleState", {})
	elif entity.velocity != Vector2.ZERO and dash_component.is_dashing:
		manager.change_state("DashState", {})
	elif entity.velocity != Vector2.ZERO and is_jumping == true:
		manager.change_state("JumpState", {})
		is_jumping = false
	elif entity.velocity == Vector2.ZERO and GLobals.spinning or entity.velocity != Vector2.ZERO and GLobals.spinning:
		manager.change_state("SpinningState", {})
