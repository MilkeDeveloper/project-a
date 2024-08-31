extends CharacterBody2D

class_name Entity

@export var navigation_component: NavigationAgent2D
@export var animation_component: Node2D

@onready var hud_entity: Control = $hud_entity
@onready var time_to_move: Timer = $time_to_move

@export var SPEED = 300.0
@export var hp: int

var direction: Vector2
var angle: float
var new_position: Vector2

func _ready() -> void:
	# inicia a função que define o movimento aleatório
	random_movement()
	hud_entity.hide()

# Define um uma posição aleatória para trajetória da entidade
func random_movement():
	angle = deg_to_rad(randf_range(0, 360))
	direction = Vector2(cos(angle), sin(angle))
	new_position = global_position + direction.normalized() * randf_range(50, 350)
	navigation_component.set_destination(new_position)
	
	# Inicia o timer com um tempo aleatório
	time_to_move.start(randf_range(1.5, 5.0))

func _on_enemy_destination_reached() -> void:
	# Se a entidade chegou ao destino, define a velocidade como 0 e o movimento para idle
	velocity = Vector2.ZERO
	animation_component.state_machine.dispatch(&"to_idle")

func _on_time_to_move_timeout() -> void:
	# Se o cooldown de movimento zerou, então chama novamente a função de movimento
	# aleatório para defininir uma nova rota de movimento
	random_movement()


func _on_mouse_entered() -> void:
	# Se o mouse está sobre a entidade, mostre a hud
	hud_entity.show()


func _on_mouse_exited() -> void:
	# Se o mouse nao está mais sobre a entidade, esconda a hud
	hud_entity.hide()
