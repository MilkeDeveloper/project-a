@tool
extends BTAction

@export var actor: StringName = &"node"
@export var jump_force := 300.0
@export var jump_distance:= 80

var is_jumping: bool = false

func _generate_name() -> String:
	return "JumpBack ➜ Distance (%s)" % LimboUtility.decorate_var(str(jump_distance))

func _tick(delta: float) -> Status:
	var _actor = blackboard.get_var(actor)
	var navigation = _actor.get_node("navigation")
	var action = _actor.get_node("Actions")
	var jump_sfx = _actor.get_node("jump_back")
	var target = blackboard.get_var(&"target")
	if not _actor or not target:
		return FAILURE
		
	_actor.set_collision_layer(0)
	_actor.set_collision_mask(0)

	var dir = (_actor.global_position - target.global_position).normalized()
	var final_position = _actor.global_position + dir * jump_distance
	if not is_jumping:
		navigation.set_destination(final_position, jump_force)
		if jump_sfx:
			jump_sfx.play(0.0)
		action.handle_reposition_anim(target)
		is_jumping = true
		print("Posição atual:", _actor.global_position, "Destino:", final_position, "Distância:", _actor.global_position.distance_to(final_position))
	
	if _actor.global_position.distance_to(final_position) < 125:
		is_jumping = false
		
		return SUCCESS
	
	return RUNNING
