extends SubViewport


@export var subplayer : CharacterBody2D
@export var _player: CharacterBody2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	subplayer.position = _player.position / 1.7
