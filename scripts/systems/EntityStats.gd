extends Resource


class_name EntityStats

@export var strength: int = 10
@export var agility: int = 10
@export var dexterity: int = 10
@export var intelligence: int = 10
@export var vitality: int = 10

var ATK_mod: float = 1.0
var DEF_mod: float = 1.0
var HIT_mod: float = 1.0
var CRIT_mod: float = 1.0
var ASPD_mod: float = 1.0

# Método para calcular um atributo derivado
func get_ATK() -> int:
	return int((strength * 1.5) + (dexterity * 1.3) * ATK_mod)

func get_minATK() -> int:
	return int((strength * 1.0) + (dexterity * 1.0) * ATK_mod)
	
func get_DEF() -> int:
	return int((vitality * 1.5) + (strength * 1.1) * DEF_mod) 

func get_minDEF() -> int:
	return int((vitality * 1.0) + (strength * 1.0) * DEF_mod) 

func get_HIT() -> int:
	return int((dexterity * 1.8) * HIT_mod)
	
func get_CRIT() -> int:
	return int(((dexterity * 1.2) + agility) * CRIT_mod)

func get_ASPD() -> int:
	return int(100 + (agility * 1.5) + ASPD_mod)

# Buffs e Debuffs
func modify_stat(stat_name: String, amount: int):
	if stat_name:
		self.set(stat_name, self.get(stat_name) + amount)
