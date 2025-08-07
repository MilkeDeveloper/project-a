extends Node2D

@export var popup_instance: PackedScene
@export var anim: AnimationPlayer
@export var dmg_effect: PackedScene
@export var dummy: Node2D
@export var SPEED: float
var _attacker: Node2D

func _ready() -> void:
	anim.play("idle")


func take_damage(damage, attacker, target_attacker, effect_anim_name):
	_attacker = attacker
	apply_anim()
	apply_hurt_effect(effect_anim_name)
	var anim_name = "new_default_dmg_2"
	var dmg_popup = popup_instance.instantiate()
	randomize()
	dmg_popup.position.x = global_position.x + randi_range(-8, 8)
	dmg_popup.position.y = global_position.y + randi_range(-8, 8)
	get_parent().get_node("take_dmg").add_child(dmg_popup)
	dmg_popup.start_popup2(damage, anim_name, attacker, target_attacker)
	
	#apply_damage(damage)

func take_basic_damage(damage, attacker, target_attacker, effect_anim_name):
	_attacker = attacker
	apply_anim()
	apply_hurt_effect(effect_anim_name)
	var anim_name = "new_default_dmg_2"
	var dmg_popup = popup_instance.instantiate()
	randomize()
	dmg_popup.position.x = global_position.x + randi_range(-8, 8)
	dmg_popup.position.y = global_position.y + randi_range(-10, 10)
	get_parent().get_node("take_dmg").add_child(dmg_popup)
	dmg_popup.start_popup2(damage, anim_name, attacker, target_attacker)

func apply_anim():
	anim.play("hurt")
	await anim.animation_finished
	anim.play("idle")

func apply_hurt_effect(hit_anim_name):
	var effect = dmg_effect.instantiate()
	add_child(effect)
	effect.start_animation(hit_anim_name)
	
func apply_status(target: Node2D, args: Dictionary):
	var status = args["status"]
	if status == "knockup":
		dummy.apply_juggle(target, args)
	if status == "knockback":
		dummy.apply_knockback(target, args)
