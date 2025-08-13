@tool
extends BTAction

@export var actor_var: StringName = &"node"
@export var speed: StringName = &"600"
@export var target = &"target" 

var ambush_target_pos: Vector2
var sight_position_locked: bool = false
var is_attacking: bool = false

func _generate_name() -> String:
	return "AmbushJump ➜ (%s)  Speed ➜ (%s)" % [
		LimboUtility.decorate_var(target),
		LimboUtility.decorate_var(str(speed)) ]

func _tick(delta: float) -> Status:
	var _target = blackboard.get_var(target)
	var actor = blackboard.get_var(actor_var)
	var state = actor.get_node("StateMachine")
	var action = actor.get_node("Actions")
	var anim = actor.get_node("anim")
	var jump = actor.get_node("status")
	var jump_sfx = actor.get_node("jump_back")
	var ambush_sfx = actor.get_node("ambush")
	var navigation: NavigationAgent2D = actor.get_node("navigation")
	
	
	if not actor:
		return FAILURE
	
	actor.can_move = true
	actor.visible = true
	actor.set_collision_layer(0)
	actor.set_collision_mask(0)
	#actor.animation_player.play("ambush_jump")
	
	# Se ainda não está no ataque, prepara
	if not is_attacking:
		ambush_target_pos = _target.global_position
		sight_position_locked = true
		is_attacking = true
		navigation.set_destination(ambush_target_pos, float(speed))
		
		jump_sfx.play(0.0)
		#jump.apply_juggle(actor, {"height": -50, "air_duration": 0.3, "fall_duration": 0.2})
		await action.handle_ambush_anim(_target)
		ambush_sfx.play(0.0)
		is_attacking = false
		
		# dispara a função assíncrona sem bloquear o _tick
		#start_attack_after_delay(state)
	
	return SUCCESS



	
