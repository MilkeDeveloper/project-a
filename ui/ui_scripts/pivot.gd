extends Marker2D

@export var _player: CharacterBody2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("mouse_right"):
		if _player != null:
			var direction = (get_global_mouse_position() - global_position).normalized()
			global_position = _player.global_position
			rotation = direction.angle()
