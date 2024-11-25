extends NavigationAgent2D

@export var node: CharacterBody2D
@export var anim_component: Node2D
# Called when the node enters the scene tree for the first time.
var direction: Vector2

signal destination_reached

# Define o destino no momento do click do mouse
func set_destination(target_position: Vector2):
	self.target_position = target_position
	if get_parent().is_in_group("player") and get_parent().get_node("basic_attack").is_attacking:
		get_parent().SPEED = get_parent().SPEED * 0.5 
		
func _process(delta):
	if is_navigation_finished():
		# Emite um sinal para o nó pai informando que a navegação terminou
		emit_signal("destination_reached")
		
		
		
	if is_navigation_finished() == false:
		# Move o personagem com base no próximo ponto da trajetória
		direction = self.get_next_path_position() - node.global_position
		
		if get_parent().is_in_group("player") and get_parent().get_node("dash_component").is_dashing:
			node.velocity = direction.normalized() * get_parent().get_node("dash_component").final_dash_speed * 15 * delta
		else:
			node.velocity = direction.normalized() * node.SPEED * 15 * delta
		
		node.move_and_slide()
		
