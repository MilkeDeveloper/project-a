extends Node

class_name Actions

@export var entity: Node2D
@export var animation: AnimationPlayer
@export var direction: DirectionTracker
@export var navigation: NavigationAgent2D
@export var movement_node: Node2D
@export var action: Node2D
@export var attacktimer: Timer



var animation_name = ""

func start_attack():
	var _attacker = get_tree().get_nodes_in_group("player").pop_front()
	await handle_attack_anim(_attacker)
	action.fire_projectile(_attacker)
	animation.play("idle_" + direction.get_action_direction(_attacker.global_position))
	

func start_patrol():
	movement_node.random_movement()
	
	
func start_chase(attaker: CharacterBody2D):
	navigation.set_destination(attaker.global_position, entity.SPEED)
	

func start_hurt(attacker: CharacterBody2D):
	animation.play("hurt_" + direction.get_action_direction(attacker.global_position))
	await animation.animation_finished
	animation.play("idle_" + direction.get_action_direction(attacker.global_position))
	
	

func start_idle():
	navigation.set_destination(entity.global_position)
	#animation.play("idle_" + direction.get_action_direction(movement_node.new_position))
	
func handle_attack_anim(attacker: Node):
	if attacker != null:
		if attacker.global_position.x < entity.global_position.x and attacker.global_position.y < entity.global_position.y:
			animation.play("attack_up")
			await animation.animation_finished
		elif attacker.global_position.x > entity.global_position.x and attacker.global_position.y < entity.global_position.y:
			animation.play("attack_up2")
			await animation.animation_finished
		elif attacker.global_position.x < entity.global_position.x and attacker.global_position.y > entity.global_position.y:
			animation.play("attack_down")
			await animation.animation_finished
		elif attacker.global_position.x > entity.global_position.x and attacker.global_position.y > entity.global_position.y:
			animation.play("attack_down2")
			
			await animation.animation_finished

func distance_to_player(attacker: CharacterBody2D) -> float:
	return entity.global_position.distance_to(attacker.global_position)

func in_range(target: Node, _min_distance: float, _max_distance: float):
	var dist_sq: float = entity.global_position.distance_squared_to(target.global_position)
	return dist_sq >= _min_distance and dist_sq <= _max_distance
		
