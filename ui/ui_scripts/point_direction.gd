extends Sprite2D

@export var _player: CharacterBody2D

var minimap_scale: Vector2 = Vector2(300.0 / 2600.0, 250.0 / 1300.0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _player != null:
		if _player.get_parent().get_node("pivot") != null:
			self.rotation = _player.get_parent().get_node("pivot").rotation
	
