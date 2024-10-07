extends Resource

class_name ItemData

@export var item_id: int
@export var item_name: String
@export var icon: Texture
@export var item_desc: String
 
@export var item_category: String
@export var usable: bool
@export var item_cost: float
@export var item_weight: float
@export var max_stacks: int
@export var stacks: int = 1
@export var stackable: bool

@export_category("weapon data")
@export var is_weapon: bool = false
@export var weapon_type: Array[String]
