extends Resource
class_name GDSkillEffectData

enum EffectType { SLOW, SHIELD, STUN, DOT, HEAL, CRIT_BUFF, LIFESTEAL, ARMOR_BREAK }

@export var type: EffectType
@export var value: float = 0.0        # % (ex: slow 50%) ou quantia (ex: shield 255)
@export var duration: float = 0.0     # em segundos
@export var chance: float = 1.0       # 1.0 = 100%
@export var max_stacks: int = 0       # opcional
@export var extra_params: Dictionary = {} # caso queira algo específico por efeito
