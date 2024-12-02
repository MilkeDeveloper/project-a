extends Node2D

@export var animation_component: Node2D
@export var navigation_component: NavigationAgent2D
@onready var time_to_move: Timer = $time_to_move

var direction: Vector2
var angle: float
var new_position: Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	random_movement()

# Define um uma posição aleatória para trajetória da entidade
func random_movement():
	angle = deg_to_rad(randf_range(0, 360))
	direction = Vector2(cos(angle), sin(angle))
	new_position = global_position + direction.normalized() * randf_range(50, 350)
	navigation_component.set_destination(new_position)
	
	# Inicia o timer com um tempo aleatório
	time_to_move.start(randf_range(1.5, 5.0))
	
func _on_time_to_move_timeout() -> void:
	# Se o cooldown de movimento zerou, então chama novamente a função de movimento
	# aleatório para defininir uma nova rota de movimento
	if not get_parent().died and get_parent().can_move:
		random_movement()

func _on_destination_reached() -> void:
	# Se a entidade chegou ao destino, define a velocidade como 0 e o movimento para idle
	get_parent().velocity = Vector2.ZERO
	
