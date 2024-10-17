extends Node2D

@export var navigation_component:  NavigationAgent2D
@export var dash_component: Node2D
@export var projectile_component: Node2D
@export var skill_component: Node2D
@export var anim_component: Node2D
@export var cam: Camera2D
@export var node: CharacterBody2D
@export var skill_mananager: Node
@export var ui_inventory: Control
@export var ui_skills: Control

var can_shoot: bool = true
var nullable: Node
var inventory_open: bool
var anim: AnimationPlayer

var action_keys = {
	"attack": "basic_attack",
	"block": "block",
	"inventory": "inventory",
	"map": "map",
	"hotbar_1": "hotbar_1",
	"hotbar_2": "hotbar_2"
}

func _ready() -> void:
	anim = ui_inventory.get_node("anim")

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
			
	if event.is_action_pressed("jump"):
		get_parent().get_node("State").is_jumping = true
	
	if event.is_action_just_pressed("shoot"):
		#skill_mananager.activate_skill("Disparo Espalhado", node, anim_component, nullable)
		print("A skill precisa de um alvo")
	
		#projectile_component.use_skill(GLobals.target)
	if event.is_action_just_pressed("skill2"):
		skill_mananager.activate_skill("Triple Shoot", node, anim_component, nullable)
		print("ativando a skill")
		
	if event.is_action_just_pressed("skill"):
		skill_mananager.activate_skill("Soul Chain", node, anim_component, nullable)
		#cam.apply_shake(0.3, 1.5)
		#skill_component.start_petagon_court(node.global_position)

	if event.is_action_just_pressed("skill4"):
		skill_mananager.activate_skill("Meteor Storm", node, anim_component, nullable)
		print("ativando a skill")
	
	if event.is_action_just_pressed("skill5"):
		skill_mananager.activate_skill("Arrow Assault", node, anim_component, nullable)
		print("ativando a skill")
		
		
	#GUI config
	if event.is_action_just_pressed("config"):
		$"../UI config".get_node("Control").visible = not $"../UI config".get_node("Control").visible
		if $"../UI config".get_node("Control").visible == false:
			ConfigManager.save_keybindings()
			print("salvando mapeamento de teclas...")
		
	
	#GUI interface
	if event.is_action_just_pressed("inventory"):
		
		if anim != null and not inventory_open:
			ui_inventory.visible = true
			anim.play("inventory_open")
			inventory_open = true
		else:
			var anim = ui_inventory.get_node("anim")
			anim.play("inventory_close")
			await anim.animation_finished
			ui_inventory.visible = false
			inventory_open = false
	
	if event.is_action_just_pressed("ui_skills"):
		ui_skills.visible = not ui_skills.visible
