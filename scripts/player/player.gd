extends CharacterBody2D

class_name Player

@export var navigation_component: NavigationAgent2D
@export var input_component: Node2D
@export var animation_component: Node2D
@export var SPEED = 300.0
@export var hp: int


func _physics_process(delta):
	# Chama a função do nó para cehgar os inputs
	input_component.get_input(Input)

func _on_destination_reached() -> void:
	# Se o node cehgou ao destino, define a velocidade para 0 e define o estado para "idle"
	velocity = Vector2.ZERO
	animation_component.state_machine.dispatch(&"to_idle")
