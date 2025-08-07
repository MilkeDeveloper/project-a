extends SkillBase

@export var speed := 800
@export var max_duration := 0.2

@export_category("Knockup Effect")
@export var status_vars: Dictionary

@export var stun_duration := 1.5
@export var lunge_speed: float
@export var dash_distance: float = 100
@export var dash_speed: float = 800
@export var dash_modifier: float
@export var ghost_effect:  PackedScene
@export var node_texture:  Sprite2D
@export var animation_component:  Node2D

var node: Node

var original_speed: float

var direction: Vector2 = Vector2.ZERO
var has_hit := false
var timer := 0.0
var final_pos: Vector2

var is_dashing: bool = false
var ghost_instance
var ghost
var final_dash_speed: float = 0.0



func _ready():
	set_physics_process(false)
	# Pega direção para o mouse global
	mouse_position = get_global_mouse_position()
	direction = (mouse_position - global_position).normalized()
	original_speed = 200

func _physics_process(delta):
	if has_hit:
		return
	
	timer += delta
	if timer >= max_duration:
		queue_free()
		return

func use_skill(_player, _damage, _cooldown, anim_component, _target = null):
	damage = _damage
	node = _player
	set_physics_process(true)
	node_texture = node.get_node("sprite")
	node.is_dashing = true
	activate_dash()
	
	status_vars["player"] = _player
	
	

func _on_body_entered(body):
	if has_hit:
		return
	
	if body.is_in_group("entity"):
		has_hit = true
		#node.can_move = false
		
		_apply_damage_and_knockback(body)
		queue_free()

func _apply_damage_and_knockback(enemy):
	if enemy.is_in_group("entity"):
		if enemy.has_method("apply_status"):
			node.get_node("StateMachineManager").change_state("SkillState", {"skill": SkillState.Skills.E2})
			enemy.apply_status(enemy, status_vars)
	
	
	if enemy.is_in_group("entity"):
		GLobals.emit_signal("cam_shake", 5.5, 0.5)
		if enemy.has_method("take_damage"):
			enemy.take_damage(damage, node, enemy, "magic_hit")
			
			node.is_dashing = false
			#node.can_move = true
			node.SPEED = original_speed
			#print(attacker, body)
		#if enemy.has_method("apply_status"):
			#enemy.apply_status(enemy,  knockup_vars)
				
	

func activate_dash():
	var target_position = (get_global_mouse_position() - node.global_position).normalized()
	target_position = node.global_position + (target_position * dash_distance)
	final_pos = target_position
	$colisor.rotation = $colisor.get_angle_to(final_pos)
	final_dash_speed = set_dash_speed()
	#node.get_node("StateMachineManager").change_state("SkillState", {"skill": SkillState.Skills.E2})
	node.get_node("navigation").set_destination(final_pos, final_dash_speed)
	
	
	
	
	#node.get_node("dash_component").dash()

func set_dash_speed():
	return  dash_speed * dash_modifier
	
