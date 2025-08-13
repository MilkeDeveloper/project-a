extends NPCBase

class_name DevilCat

func _ready() -> void:
	hp = data.max_hp
	
func _process(delta: float) -> void:
	$state_label.text = str(state.get_active_state())
	
func take_damage(damage, attacker, target_attacker, effect_anim_name):
	get_node("ambush_hitbox").monitoring = false
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
	state.dispatch(&"hurted")
	
	
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
	#anim.play("hurt")
	#await anim.animation_finished
	#anim.play("idle")
	pass

func apply_hurt_effect(hit_anim_name):
	var effect = dmg_effect.instantiate()
	add_child(effect)
	effect.start_animation(hit_anim_name)
	
func apply_status(target: Node2D, args: Dictionary):
	var _status = args["status"]
	if _status == "knockup":
		status.apply_juggle(target, args)
	if _status == "knockback":
		status.apply_knockback(target, args)

func set_as_target():
	is_targeted = true
	show_target_marker()

func clear_target():
	is_targeted = false
	hide_target_marker()

func show_target_marker():
	# Exemplo: ativa um nó Sprite ou AnimationPlayer que indica seleção
	if has_node("TargetMarker"):
		get_node("TargetMarker").visible = true
		get_node("TargetMarker").get_node("target_anim").play("target_motion")

func hide_target_marker():
	if has_node("TargetMarker"):
		get_node("TargetMarker").visible = false
		get_node("TargetMarker").get_node("target_anim").stop()
