extends StateData

class_name Death

func _enter() -> void:
	pass

func _update(delta: float) -> void:
	animation.play("death_" + direction.get_direction())
