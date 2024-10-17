extends Resource

class_name GDSkillData

@export var id: int
@export var skill_name: String
@export var skill_description: String
@export var skill_icon: Texture
@export var mana_cost: int
@export var cooldown: float
@export var charge_time: float
@export var effect_type: String
@export var damage: int
@export var heal: int
@export var skill_effect: PackedScene
@export var skill_level: int
@export var skill_max_level: int
@export var is_passive: bool
@export var weapon_required: String
@export var is_charging_skill: bool
@export var is_aim_skill: bool
@export var is_target_skill: bool
@export var grimoire_Slots: Array[SkillCardData]

var cooldown_left: float
