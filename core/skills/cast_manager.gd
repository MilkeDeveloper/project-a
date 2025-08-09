extends SkillManager

class_name CastManager

var cast_time: float
var time: float = 0.0
var _is_on_cast: bool 

func start_cast(skill_data: GDSkillData):
	# Inicia ou reinicia o cooldown da skill
	cast_time = skill_data.cast_time
	time = 0.0
	_is_on_cast = true

func update_cast(delta: float):
	# Atualiza todos os cooldowns ativos
	time += delta
	if time >= cast_time:
		_is_on_cast = false
		time = 0.0

func is_on_cast() -> bool:
	# Retorna true se a skill ainda estiver no cooldown
	return _is_on_cast
		
