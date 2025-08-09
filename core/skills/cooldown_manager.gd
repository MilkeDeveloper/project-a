extends SkillManager

class_name CoolddownManager

var active_cooldowns: Array[GDSkillData] = []

func start_cooldown(skill_data: GDSkillData):
	# Inicia ou reinicia o cooldown da skill
	skill_data.cooldown_left = skill_data.cooldown
	active_cooldowns.append(skill_data)

func update_cooldowns(delta: float):
	# Atualiza todos os cooldowns ativos
	for skill_id in active_cooldowns:
		skill_id.cooldown_left -= delta
		if skill_id.cooldown_left <= 0:
			active_cooldowns.erase(skill_id) # Remove a skill da lista de cooldowns ativos quando o tempo acaba

func is_on_cooldown(skill_id: GDSkillData) -> bool:
	# Retorna true se a skill ainda estiver no cooldown
	return active_cooldowns.has(skill_id)
