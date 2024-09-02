extends Node

signal target_found(node)

var target: Node2D = null
var mouse_over: bool = false
var targets: Array[Node2D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
