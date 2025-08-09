extends Resource

class_name GDSkillData

enum SkillType {DAMAGE, HEAL, BUFF, DEBUFF}
enum SkillStates {USED, IN_COOLDOWN, AVAILABLE}
enum SpellType {CAST, AIM, CHARGE, INSTACAST}


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
@export var essence_required: Array[int] = [0, 10, 20, 30, 50]
@export var skill_essences: int
@export var cast_time: float = 0
@export var spell_type: SpellType
@export var max_skill_charges: int
@export var skill_interaction_effects: Array[SkillINteractionsData]

var cooldown_left: float
var cast_left: float
var skill_states: SkillStates
var skill_charges: int = 1
