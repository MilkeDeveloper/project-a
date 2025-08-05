@tool
extends BTAction

@export var target_var := "target"
@export var speed_mod := 800.0
@export var trigger_time := 1.5
@export var end_distance := 5.0
@export var offset: float = 100.0


var dash_started := false
var target_pos

func _enter() -> void:
	var anim = agent.get_node_or_null("anim")
	var direction = agent.get_node_or_null("DirectionTracker")
	var target = blackboard.get_var(target_var)
	blackboard.set_var("action_active", true)
	
	if anim:
		
		anim.play("ascend_" + direction.get_action_direction(target.global_position))
		

func _tick(delta: float) -> Status:
	var anim = agent.get_node_or_null("anim")
	var navigation = agent.get_node_or_null("navigation")
	var direction = agent.get_node_or_null("DirectionTracker")
	var target = blackboard.get_var(target_var)
	if not anim or not target:
		return FAILURE
	
	if anim.get_current_animation_position() >= 1.4 and anim.get_current_animation_position() <= 1.6:
		target_pos = target.global_position
	
	if anim and anim.get_current_animation_position() >= 3.0:
		var current_frame = anim.current_animation_position
		anim.play("ascend_" + direction.get_action_direction(target.global_position))
		anim.seek(current_frame, true)
		
	# Espera atingir o tempo da animação
	navigation.set_destination(agent.global_position, agent.SPEED)
	if anim.get_current_animation_position() >= trigger_time:
		if not dash_started:
			var dir = (target_pos - agent.global_position)
			agent.velocity = dir * speed_mod * delta

		agent.move_and_slide()
		
		
		if anim.get_current_animation_position() >= 3.9 and agent.global_position.distance_to(target_pos) <= end_distance:
			#blackboard.set_var("action_active", false)
			
			print(blackboard.get_var("action_active"))
			return SUCCESS
	
	return RUNNING
