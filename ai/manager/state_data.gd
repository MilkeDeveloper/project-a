extends BTState

class_name StateData

@export var actor: CharacterBody2D
@export var action: Node
@export var entity_action: Node2D
@export var animation: AnimationPlayer
@export var direction: DirectionTracker
@export var movement_node: Node2D
@export var navigation : NavigationAgent2D
@export var hurt_timer: Timer

@export var min_distance: float
@export var max_distance: float

var target

var max_squared_distance: float
var min_squared_distance: float
