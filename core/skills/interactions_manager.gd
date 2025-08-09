extends SkillManager

class_name InteractionsManager

func verify_skill_interactions(last_skill_ID: GDSkillData, skill_data: GDSkillData):
	if skill_data.skill_interaction_effects.size() > 0:
		for effect in skill_data.skill_interaction_effects:
			if effect.Skill_ID == last_skill_ID.id:
				apply_skill_effect(effect.Skill_effects, last_skill_ID, effect.Percentage)
			else:
				for skill in used_skills:
					if skill.id == effect.Skill_ID:
						if skill.skill_states == 1:
							apply_skill_effect(effect.Skill_effects, skill, effect.Percentage)
	
			
func apply_skill_effect(skill_effect: SkillINteractionsData.Effects, last_skill_data: GDSkillData, percentage: float):
		match skill_effect:
			SkillINteractionsData.Effects.COOLDOWN_REDUCTION:
				print("cooldown reduzido")
				if last_skill_data.cooldown_left > 0:
					var total_cooldown = last_skill_data.cooldown *(1 - percentage / 100)
					last_skill_data.cooldown_left = max(0, min(total_cooldown, last_skill_data.cooldown_left * (total_cooldown / last_skill_data.cooldown)))
			SkillINteractionsData.Effects.LIFESTEAL:
				print("curando em 2,5% do dano causado")
