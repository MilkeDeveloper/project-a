extends Resource

class_name NpcData

enum NpcType {
	AGRESSIVE,
	PASSIVE,
	NPC,
	GUARD
}

@export var id: int
@export var npc_name: String
@export var lvl: int
@export var max_hp: int
@export var speed: float
@export var damage: int
@export var attack_range: float
@export var seek_range: float
@export var type: NpcType
@export var def: int
@export var exp_drop: int
@export var ai_behavior: AIBehaviorData
