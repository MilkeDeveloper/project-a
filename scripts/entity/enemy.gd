extends CharacterBody2D

class_name Entity

@export var _name: String
@export var SPEED = 300.0
@export var max_hp: int
@export var level: int

@onready var hud_entity: Control = $hud_entity
@onready var animation_component: Node2D = $animation_component

@export var popup_instance: PackedScene
@export var dmg_effect: PackedScene

var mouse_over: bool = false
var targeted: bool = false
var can_move: bool = true
var hp: int = max_hp
var died: bool
var hited_enemies: Array = []
var hurted: bool = false
var supressed: bool = false

func _ready() -> void:
	# inicia a função que define o movimento aleatório
	hp = max_hp
	hud_entity.update_bars(hp)
	hud_entity.hide()
	
	
	#hud_entity.get_node("HUD_HP").find_child("bar").get_child(0).text = str(hp) + "/" + str(max_hp)
func _process(delta: float) -> void:
	if hp < max_hp:
		hud_entity.show()
		
	
	if hp <= 0:
		died = true
		die()

func take_damage(damage, attacker, target_attacker, effect_anim_name):
	apply_hurt_effect(effect_anim_name)
	var anim_name = "default_dmg"
	var dmg_popup = popup_instance.instantiate()
	randomize()
	dmg_popup.position.x = global_position.x + randi_range(-32, 32)
	dmg_popup.position.y = global_position.y + randi_range(-32, -64)
	get_parent().get_node("take_dmg").add_child(dmg_popup)
	dmg_popup.start_popup2(damage, anim_name, attacker, target_attacker)
	apply_damage(damage)
	get_node("navigation").set_process(false)
	await get_tree().create_timer(0.3).timeout
	get_node("navigation").set_process(true)
	GLobals.target = target_attacker
	$target_area.set_hud_target()
	hurted = true
	animation_component.state_machine.dispatch(&"to_hurt")
	
func apply_hurt_effect(hit_anim_name):
	hurted = true
	var effect = dmg_effect.instantiate()
	add_child(effect)
	effect.start_animation(hit_anim_name)

func apply_damage(amount):
	hp -= amount
	hp = max(hp, 0)
	hud_entity.update_bars(hp)
	
func die():
	GLobals.target = null
	$navigation.set_process(false)
	$target_area._clear_target()
	$sprite.hide()
	hud_entity.hide()
	$colision.hide()
	$colision.disabled = true
	await get_tree().create_timer(1.0).timeout
	queue_free()
