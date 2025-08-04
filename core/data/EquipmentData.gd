extends Resource

class_name EquipmentData

enum EquipType {HELMET, ARMOR, SHOES, CAPE}
enum EquipRarity {COMMON, UNCOMMON, RARE, EPIC, LEGENDARY}
enum EnchantLvL {LVL0, LV1, LV2, LV3 , LV4}
enum TierLvL {T1, T2, T3, T4, T5, T6, T7}

@export var id: int
@export var e_name: String
@export var description: String
@export var icon: Texture
@export var tier: TierLvL
@export var rarity: EquipRarity
@export var enchant_lvl: EnchantLvL
@export var type: EquipType
@export var stats: EquipmentTypeData
@export var price: int
@export var weight: int
@export var durability: int
