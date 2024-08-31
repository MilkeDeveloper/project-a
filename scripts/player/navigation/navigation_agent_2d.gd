extends NavigationAgent2D

@export var node: CharacterBody2D
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
		node.move_and_slide()
