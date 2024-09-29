extends Node

#general signals
signal target_found(node)
signal cam_shake(intesity, duration)
signal start_anim
signal body_entered(body)

#skill signals
signal key_skill_released(_skill_name: String)
signal on_click

var target: Node2D = null
var mouse_over: bool = false
var targets: Array[Node2D] = []
var spinning: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
