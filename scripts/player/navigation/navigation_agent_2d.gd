extends NavigationAgent2D

@export var node: CharacterBody2D
@export var anim_component: Node2D
# Called when the node enters the scene tree for the first time.
var direction: Vector2
var speed: float

signal destination_reached

# Define o destino no momento do click do mouse
func set_destination(target_position: Vector2, _speed: float):
	self.target_position = target_position
	speed = _speed
	
		
func _process(delta):
	if not node.can_move:
		set_destination(node.global_position, node.SPEED)
		return
	
	if is_navigation_finished():
		# Emite um sinal para o nó pai informando que a navegação terminou
		emit_signal("destination_reached")
		
		
		
		
	if is_navigation_finished() == false:
		# Move o personagem com base no próximo ponto da trajetória
		direction = self.get_next_path_position() - node.global_position
		
		if get_parent().is_in_group("player") and get_parent().is_dashing:
			node.velocity = direction.normalized() * speed * 15 * delta
		elif get_parent().is_in_group("player") and get_parent().get_node("basic_attack").is_attacking:
			node.velocity = direction.normalized() * node.SPEED * 15 * delta
		#elif get_parent().is_in_group("player") and get_parent().is_in_combat:
			#node.velocity = Vector2.ZERO
		else:
			node.velocity = direction.normalized() * node.SPEED * 15 * delta
		
		
		node.move_and_slide()
	
		
