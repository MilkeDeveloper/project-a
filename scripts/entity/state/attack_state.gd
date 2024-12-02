extends State


class_name EntityAttackState

@export var action_node: Node2D

var attacker

func _ready() -> void:
	attack_timer.start()

# Função que é chamada ao entrar no estado
func enter(args: Dictionary = {}) -> void:
	print("attack state")
	if "target" in args:
		attacker = args["target"]
		Combat.can_move = false
		Combat.is_attacking = true
		
# Função chamada enquanto o estado está ativo
func update(delta: float) -> void:
	transit_state()

# Função chamada quando saímos do estado
func exit() -> void:
	pass

# Função que lida com as animações do estado atual
func handle_anim():
	if attacker != null:
		if attacker.global_position.x < entity.global_position.x and attacker.global_position.y < entity.global_position.y:
			animation.play("attack_up")
		elif attacker.global_position.x > entity.global_position.x and attacker.global_position.y < entity.global_position.y:
			animation.play("attack_up2")
		elif attacker.global_position.x < entity.global_position.x and attacker.global_position.y > entity.global_position.y:
			animation.play("attack_down")
		elif attacker.global_position.x > entity.global_position.x and attacker.global_position.y > entity.global_position.y:
			animation.play("attack_down2")
		
		await animation.animation_finished
		handle_wait_anim()
	
# Função para transitar para outros estados
func transit_state():
	if entity.hp <= 0:
		manager.change_state("DeathState")


func _on_attack_timer_timeout() -> void:
	Combat.can_attack = true
	handle_anim()
	handle_attack()
	attack_timer.start()
	
func chase(attacker: CharacterBody2D):
	if entity.global_position.distance_to(attacker.global_position) > entity.attack_range:
		Combat.is_attacking = false
		

func handle_wait_anim():
	navigation.set_destination(entity.global_position)
	animation.play("idle_" + direction_tracker.get_direction())
	

func handle_attack():
	if attacker != null:
		if entity.hp > 0:
			if distance_to_player() > entity.attack_range and not entity.died:
				manager.change_state("ChaseState", {"target": attacker})
			else:
				#navigation.set_destination(entity.global_position)
				action_node.fire_projectile(attacker)

func distance_to_player() -> float:
	return entity.global_position.distance_to(attacker.global_position)
