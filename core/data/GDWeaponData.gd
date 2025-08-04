extends Resource

class_name GDWeaponData

enum DataType {SWORD, AXE, CROSSBOW, BOW, FIST, STAFF}
enum WeaponRarity {COMMON, UNCOMMON, RARE, EPIC, LEGENDARY}
enum EnchantLvL {LVL0, LV1, LV2, LV3 , LV4}
enum TierLvL {T1, T2, T3, T4, T5, T6, T7}
enum AttackType { MELEE, RANGED, MAGIC }

@export var id: String
@export var name: String
@export var description: String
@export var icon: Texture
@export var tier: TierLvL
@export var rarity: WeaponRarity
@export var enchant_lvl: EnchantLvL
@export var type: DataType
@export var attack_type: AttackType
@export var stats: WeaponStatsData
@export var skills_Q: GDSkillData
@export var skills_W: GDSkillData
@export var skills_E: GDSkillData
@export var skills_R: Array[GDSkillData]
@export var passives: Array[PassiveSkillData]
@export var weight: int
@export var price: int
@export var durability: int
