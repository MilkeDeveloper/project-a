extends Resource
class_name ComboBuildData

@export var name: String

@export var weapon: GDWeaponData
@export var helmet: EquipmentData
@export var armor: EquipmentData
@export var boots: EquipmentData

@export var set_effects: Array[SetEffectsData]    # "Crit +20%", "LifeSteal +5%", etc
@export var skill_e_modifier: GDSkillEffectData  # <- aqui entra o recurso acima

@export var tags: Array[String] = []
@export var notes: String = ""
