extends Resource

class_name BuffTypeData

enum BuffType {DAMAGE, HEAL, COOLDOWN_REDUCTION, MAX_HEALTH, ATK, DEF, MATK, MDEF, STR, AGI, CON, INT, DEX, LUCK}

@export var type: BuffType
@export var amount: float
@export var mod_percentage: float
