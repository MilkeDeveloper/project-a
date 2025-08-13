@tool
extends BTAction

@export var actor: StringName = &"node"
@export var dash_speed := 500.0
@export var distance: = 80

var sfx_is_playing : bool = false

func _generate_name() -> String:
	return "DashToTarget ➜ Speed (%s)" % LimboUtility.decorate_var(str(dash_speed))

func _tick(delta: float) -> Status:
	var _actor = blackboard.get_var(actor)
	var locked_pos = blackboard.get_var(&"locked_target_pos")
	var action = _actor.get_node("Actions")
	var dash_sfx = _actor.get_node("dash")
	var hit_sfx = _actor.get_node("hit")
	if not _actor or locked_pos == null:
		return FAILURE
	
	_actor.set_collision_layer(1)
	_actor.get_node("ambush_hitbox").get_child(0).disabled = false
	_actor.get_node("ambush_hitbox").monitoring = true
	
	if not sfx_is_playing:
		dash_sfx.play(0.0)
		sfx_is_playing = true
	action.handle_roll_anim(locked_pos)
	var dir = (locked_pos - _actor.global_position).normalized()
	_actor.velocity = dir * dash_speed
	
	_actor.move_and_slide()
	
	
	# Caso queira terminar quando chegar perto:
	if _actor.global_position.distance_to(locked_pos) < 10:
		_actor.get_node("ambush_hitbox").get_child(0).disabled = true
		sfx_is_playing = false
		hit_sfx.play(0.0)
		action.handle_attack_anim(_actor)
		return SUCCESS

	return RUNNING
