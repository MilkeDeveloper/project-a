extends SkillManager

class_name ValidatorManager

@export var skill_state: SkillState

func can_use_skill(skill_data: GDSkillData, player: CharacterBody2D, cooldown_manager: CoolddownManager, target = null) -> bool:
	# Valida se a skill está em cooldown
	if cooldown_manager.is_on_cooldown(skill_data):
		return false

	# Valida cada tipo de skill
	match  skill_data.spell_type:
		skill_data.SpellType.CAST:
			return validate_cast_skill(skill_data, player)
		skill_data.SpellType.AIM:
			return validate_aim_skill(skill_data, player, target)
		skill_data.SpellType.CHARGE:
			return validade_charge_skill(skill_data, player)
		skill_data.SpellType.INSTACAST:
			return validade_instacast_skill(skill_data, player)
			
	return false
	
func validate_cast_skill(skill_data: GDSkillData, player: CharacterBody2D) -> bool:
	if cast.is_on_cast():
		return false
	else:
		return true
	
func validate_aim_skill(skill_data: GDSkillData, player: CharacterBody2D, target: Node2D) -> bool:
	if skill_state.is_locked:
		return false
	else:
		return true
	
func validade_charge_skill(skill_data: GDSkillData, player: CharacterBody2D) -> bool:
	return false
	
func validade_instacast_skill(skill_data: GDSkillData, player: CharacterBody2D) -> bool:
	return true
