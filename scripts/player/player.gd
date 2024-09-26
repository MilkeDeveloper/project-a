extends CharacterBody2D

class_name Player

@export var navigation_component: NavigationAgent2D
@export var input_component: Node2D
@export var animation_component: Node2D
@export var dash_component: Node2D
@export var SPEED = 300.0
@export var hp: int

func _ready() -> void:
	$sprite2.hide()
	GLobals.connect("cam_shake", _on_cam_shake)

func _physics_process(delta):
	# Chama a função do nó para checar os inputs
	input_component.get_input(Input)
	if not GLobals.target:
		get_node("basic_attack").is_attacking = false
		#SPEED = 650
		return
	
func _on_destination_reached() -> void:
	# Se o node cehgou ao destino, define a velocidade para 0 e define o estado para "idle"
	if dash_component.is_dashing:
		dash_component.end_dash()

	velocity = Vector2.ZERO
	#animation_component.state_machine.dispatch(&"to_idle")
	

func _on_cam_shake(intensity, duration):
	$sprite/cam.apply_shake(duration, intensity)
	
	
