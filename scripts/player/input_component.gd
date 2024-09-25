extends Node2D

@export var navigation_component:  NavigationAgent2D
@export var dash_component: Node2D
@export var projectile_component: Node2D
@export var skill_component: Node2D
@export var anim_component: Node2D
@export var cam: Camera2D
@export var node: CharacterBody2D
@export var skill_mananager: Node

var can_shoot: bool = true
var nullable: Node

# Checa os inputs do player
func get_input(event):
	if event.is_action_pressed("mouse_right") and not dash_component.is_dashing:
		# Chama a função do NavigationComponent2D para definir o destino
		navigation_component.set_destination(get_global_mouse_position())

	if event.is_action_just_pressed("dash"):
		dash_component.dash()
	
	if event.is_action_pressed("basic_attack"):
		if GLobals.target != null:
			get_parent().find_child("basic_attack").ranged_basic_attack(GLobals.target)
	
	if event.is_action_just_pressed("shoot"):
		skill_mananager.activate_skill("Disparo Espalhado", node, anim_component, nullable)
		print("A skill precisa de um alvo")
	
		#projectile_component.use_skill(GLobals.target)
	if event.is_action_just_pressed("skill2"):
		skill_mananager.activate_skill("Triple Shoot", node, anim_component, nullable)
		print("ativando a skill")
		
	if event.is_action_just_pressed("skill"):
		skill_mananager.activate_skill("Soul Chain", node, anim_component, nullable)
		#cam.apply_shake(0.3, 1.5)
		#skill_component.start_petagon_court(node.global_position)
