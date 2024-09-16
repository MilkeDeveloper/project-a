extends NavigationAgent2D

@export var node: CharacterBody2D
@export var anim_component: Node2D
# Called when the node enters the scene tree for the first time.
var direction: Vector2

signal destination_reached

# Define o destino no momento do click do mouse
func set_destination(target_position: Vector2):
	self.target_position = target_position

func _process(delta):
	if is_navigation_finished():
		# Emite um sinal para o nó pai informando que a navegação terminou
		emit_signal("destination_reached")
		
		
	if is_navigation_finished() == false:
		# Move o personagem com base no próximo ponto da trajetória
		direction = self.get_next_path_position() - node.global_position
		node.velocity = direction.normalized() * node.SPEED * 15 * delta
		if anim_component != null:
			if GLobals.target != null and node.is_in_group("player") and node.global_position.distance_to(GLobals.target.global_position) < 300:
				anim_component.update_blend_position(GLobals.target.global_position)
			else:
				anim_component.update_blend_position(get_next_path_position())
		node.move_and_slide()
