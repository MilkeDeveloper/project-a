extends State

class_name SkillState

@export var VFX: PackedScene

enum Skills {
	Q,
	W,
	E,
	R,
}

var time: float = 0.0
var skill
var target_position: Vector2
var skill_anim_finished: bool = true

func enter(args: Dictionary = {}) -> void:
	skill = args.get("skill", -1)
	
	if skill == Skills.R:
		target_position = args["target_pos"]
		
	entity.can_move = false
	
	handle_anim()


# Função chamada enquanto o estado está ativo
func update(delta: float) -> void:
	time += delta
	if skill == Skills.R and skill_anim_finished and time >= 0.6:
		end_skill()
	if skill == Skills.E and skill_anim_finished and time >= 0.3:
		end_skill()
	if skill == Skills.Q and skill_anim_finished and time >= 0.3:
		end_skill()

# Função chamada quando saímos do estado
func exit() -> void:
	pass

# Método opcional para transições rápidas entre estados
func handle_input(event: InputEvent) -> void:
	pass

func handle_anim():
	match skill:
		Skills.E:
			is_locked = true
			animation.play("sword_skill1_" + direction_tracker.get_action_direction(entity.get_global_mouse_position()))
			$"../../sword_skillSFX".play(0.0)
			
			await get_tree().create_timer(0.3).timeout
			$"../../impact_SFX".play(0.0)
			
		Skills.Q:
			is_locked = true
			skill_anim_finished = false
			animation.play("swordAttack2_" + direction_tracker.get_action_direction(entity.get_global_mouse_position()))
			$"../../sword_SFX".play(0.0)
			skill_anim_finished = true
			#await animation.animation_finished
		Skills.R:
			is_locked = true
			entity.can_move = true
			navigation.set_destination(target_position, entity.SPEED * 3)
			animation.play("skill_fall_" + direction_tracker.get_action_direction(entity.get_global_mouse_position()))
			await animation.animation_finished
			
			
			var vfx_instance = VFX.instantiate()
			vfx_instance.global_position = target_position
			get_tree().current_scene.add_child(vfx_instance)
			vfx_instance.get_dmg_data({"damage": 350, "attacker": entity})
			
func transit_state():
	manager.change_state("IdleState") 

func end_skill():
	time = 0.0
	entity.can_move = true
	is_locked = false
	transit_state()
