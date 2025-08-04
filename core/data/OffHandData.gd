extends Resource

class_name OffHandData

enum EquipRarity {COMMON, UNCOMMON, RARE, EPIC, LEGENDARY}
enum EnchantLvL {LVL0, LV1, LV2, LV3 , LV4}
enum TierLvL {T1, T2, T3, T4, T5, T6, T7}

@export var id: String
@export var name: String
@export var description: String
@export var icon: Texture
@export var tier: TierLvL
@export var rarity: EquipRarity
@export var enchant_lvl: EnchantLvL
@export var cooldown_reduction: float
@export var crounch_control: float
@export var atk_bonus: int
@export var attack_speed_bonus: float
@export var range_bonus: float
@export var crit_chance_bonus: float
@export var max_health_bonus: float
@export var max_spirit_bonus: float
@export var heath_regen_bonus: float
@export var spirit_regen_bonus: float
@export var weight: int
@export var price: int
@export var durability: int
