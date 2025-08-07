extends State

class_name SkillState

enum Skills {
	E1,
	E2,
	E3
}

var time: float = 0.0
var skill

func enter(args: Dictionary = {}) -> void:
	skill = args.get("skill", -1)
	handle_anim()
	entity.can_move = false


# Função chamada enquanto o estado está ativo
func update(delta: float) -> void:
	await get_tree().create_timer(0.3).timeout
	entity.can_move = true
	GLobals.emit_signal("cam_shake", 40.5, 0.7)
	
	
	transit_state()

# Função chamada quando saímos do estado
func exit() -> void:
	pass

# Método opcional para transições rápidas entre estados
func handle_input(event: InputEvent) -> void:
	pass

func handle_anim():
	match skill:
		Skills.E1:
			animation.play("sword_skill1_" + direction_tracker.get_action_direction(entity.get_global_mouse_position()))
			$"../../sword_skillSFX".play(0.0)
			await get_tree().create_timer(0.3).timeout
			$"../../impact_SFX".play(0.0)
		Skills.E2:
			animation.play("swordAttack2_" + direction_tracker.get_action_direction(entity.get_global_mouse_position()))
			$"../../sword_SFX".play(0.0)
			#await animation.animation_finished
		Skills.E3:
			pass
	
func transit_state():
	manager.change_state("IdleState") 
