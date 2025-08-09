extends Node2D

@export var sprite: Sprite2D
@export var navigation: NavigationAgent2D

func apply_juggle(enemy: Node2D, args: Dictionary):
	

	# Desativa IA, animação ou movimento, se necessário
	enemy.set_physics_process(false)  # ou qualquer flag de controle do seu sistema
	
	var tween := get_tree().create_tween()
	var original_pos := sprite.global_position

	# Subida (rápida)
	tween.tween_property(sprite, "global_position:y", original_pos.y + args["height"], args["air_duration"]).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	# Queda (acelera no fim)
	tween.tween_property(sprite, "global_position:y", original_pos.y, args["fall_duration"]).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	# Reativa IA ou movimento quando o tween acabar
	tween.connect("finished", Callable(self, "_on_juggle_finished").bind(enemy))

func apply_knockback(enemy: Node2D, args: Dictionary):
	var knockback_force = args["knockback_force"]
	var knockback_dir = (enemy.global_position - args["player"].global_position).normalized()
	var knockback_pos = enemy.global_position + knockback_dir * knockback_force
	
	
	navigation.set_destination(knockback_pos, knockback_force * 10)
	
	

func _on_juggle_finished(enemy):
	enemy.set_physics_process(true)
