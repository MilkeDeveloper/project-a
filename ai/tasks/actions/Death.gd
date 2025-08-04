@tool
extends BTAction
class_name BTAction_Death

@export var animation_player_var: StringName = &"animation"
@export var direction_tracker_var: StringName = &"direction_tracker"
@export var attack_timer_var: StringName = &"attack_timer"
@export var actor_var: StringName = &"actor"

func _generate_name() -> String:
	return "Play Death Anim"

func _tick(_delta: float) -> Status:
	var actor = blackboard.get_var(actor_var)
	var animation = actor.get_node("anim")
	var direction_tracker = actor.get_node("DirectionTracker")
	var attack_timer = actor.get_node("attack_timer")

	if animation and direction_tracker and attack_timer:
		var dir = direction_tracker.get_direction()
		animation.play("death_" + dir)
		attack_timer.stop()
		blackboard.set_var(&"is_attacking", false)
		return SUCCESS

	return FAILURE
