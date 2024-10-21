extends Resource

class_name GDSkillData

enum SkillType {DAMAGE, HEAL, BUFF, DEBUFF}

@export var id: int
@export var skill_name: String
@export var skill_description: String
@export var skill_icon: Texture
@export var skill_type: Array[SkillType]
@export var buff_type: Array[BuffTypeData]
@export var mana_cost: int
@export var cooldown: float
@export var dmg_amount: int
@export var charge_time: float
@export var effect_type: String
@export var amount: int
@export var percentage: int
@export var skill_effect: PackedScene
@export var skill_level: int
@export var skill_max_level: int
@export var is_passive: bool
@export var weapon_required: String
@export var cast_time: float = 0
@export var is_charging_skill: bool
@export var is_aim_skill: bool
@export var is_target_skill: bool
@export var grimoire_Slots: Array[SkillCardData]

var cooldown_left: float
