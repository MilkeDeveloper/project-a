extends NPCBase

class_name Entity

@export var _name: String
@export var SPEED = 300.0
@export var max_hp: int
@export var level: int
@export var damage: int
@export var detection_range: float
@export var attack_range: float
@export var limbo_tree: LimboHSM
@export var action: Node

@onready var hud_entity: Control = $sprite/hud_entity
@onready var delayed_bar: TextureProgressBar = get_node("sprite/hud_entity/daleyed_hpbar")


@export var state_manager: StateMachineManager

var mouse_over: bool = false
var targeted: bool = false

var hited_enemies: Array = []
var hurted: bool = false
var supressed: bool = false

var hited: bool = false

var current_hp = 100
var delayed_hp = 100

@export var delay_speed: float

var current_posX: float
var current_posY: float

func _ready() -> void:
	# inicia a função que define o movimento aleatório
	hp = max_hp
	current_hp = max_hp
	delayed_hp = max_hp
	
	hud_entity.update_bars(hp)
	hud_entity.hide()
	


	#hud_entity.get_node("HUD_HP").find_child("bar").get_child(0).text = str(hp) + "/" + str(max_hp)
func _process(delta: float) -> void:
	if hp < max_hp:
		hud_entity.show()
	
	if hp <= 0:
		died = true
		limbo_tree.change_active_state(limbo_tree.states["death"])
		die()
		
	if delayed_hp > current_hp:
		delayed_hp = max(delayed_hp - delay_speed * delta, current_hp)
		var percent = float(delayed_hp) / max_hp
		delayed_bar.value = percent * 100
	
	current_posX = global_position.x
	current_posY = global_position.y
	
func take_damage(damage, attacker, target_attacker, effect_anim_name):
	_attacker = attacker
	apply_hurt_effect(effect_anim_name)
	var anim_name = "new_default_dmg_2"
	var dmg_popup = popup_instance.instantiate()
	randomize()
	dmg_popup.position.x = current_posX + randi_range(-8, 8)
	dmg_popup.position.y = current_posY + randi_range(-8, 8)
	get_parent().get_node("take_dmg").add_child(dmg_popup)
	dmg_popup.start_popup2(damage, anim_name, attacker, target_attacker)
	apply_damage(damage)
	get_node("navigation").set_process(false)
	#state_manager.change_state("HurtState", {"target": attacker})
	await get_tree().create_timer(0.1).timeout
	get_node("navigation").set_process(true)
	if not GLobals.target:
		GLobals.target = target_attacker
		$target_area.set_hud_target()
		attacker.get_node("TargetManager").lock_target()
	#attacker.find_child("basic_attack").ranged_basic_attack(GLobals.target)
	hurted = true
	
	if hp <= 0:
		state_manager.change_state("DeathState")
		attacker.get_node("TargetManager").unlock_target()
		

func take_basic_damage(damage, attacker, target_attacker, effect_anim_name):
	_attacker = attacker
	apply_hurt_effect(effect_anim_name)
	var anim_name = "new_default_dmg_2"
	var dmg_popup = popup_instance.instantiate()
	randomize()
	dmg_popup.position.x = current_posX + randi_range(-8, 8)
	dmg_popup.position.y = current_posY + randi_range(-10, 10)
	get_parent().get_node("take_dmg").add_child(dmg_popup)
	dmg_popup.start_popup2(damage, anim_name, attacker, target_attacker)
	apply_damage(damage)
	get_node("navigation").set_process(false)
	#state_manager.change_state("HurtState", {"target": attacker})
	await get_tree().create_timer(0.1).timeout
	get_node("navigation").set_process(true)
	attacker.get_node("TargetManager").lock_target()
	#attacker.find_child("basic_attack").ranged_basic_attack(GLobals.target)
	hurted = true
	
	if hp <= 0:
		#state_manager.change_state("DeathState")
		attacker.get_node("TargetManager").unlock_target()
		


func apply_hurt_effect(hit_anim_name):
	hurted = true
	var effect = dmg_effect.instantiate()
	add_child(effect)
	effect.start_animation(hit_anim_name)
	action.start_hurt(_attacker)

func apply_damage(amount):
	limbo_tree.dispatch(&"hurted")
	hp -= amount
	hp = max(hp, 0)
	current_hp = max(current_hp - amount, 0)
	hud_entity.update_bars(hp)
	
func die():
	GLobals.target = null
	$navigation.set_process(false)
	$target_area._clear_target()
	hud_entity.hide()
	$colision.hide()
	$colision.disabled = true
	_attacker.is_in_combat = false
	_attacker.combat_timer.start()
