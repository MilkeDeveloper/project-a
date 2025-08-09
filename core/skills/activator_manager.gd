extends SkillManager

class_name ActivatorManager

var _skill_data: GDSkillData

func instantiate_skill(skill_data: GDSkillData, player: CharacterBody2D, target: Node2D = null):
	skill_instance = skill_data.skill_effect.instantiate()
	player.add_child(skill_instance)
	_skill_data = skill_data
	skill_instance.use_skill(player, skill_data.dmg_amount, skill_data.cooldown, target)
	

func update_skill_instance(delta):
	if clicked:
		cooldowns.start_cooldown(_skill_data)
		clicked = false
