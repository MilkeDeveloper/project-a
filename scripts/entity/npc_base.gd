extends CharacterBody2D

class_name NPCBase

@export var data: NpcData 
@export var anim: AnimationPlayer
@export var movement: NPCMovement
@export var status: Node2D
@export var navigation: NavigationAgent2D
@export var popup_instance: PackedScene
@export var dmg_effect: PackedScene
@export var state: StateMachine

var is_targeted: bool = false
var _attacker: Node2D
var map_npc_id: String
var died: bool = false
var can_move: bool = true
var hp: int
