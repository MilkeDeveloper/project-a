extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var fade_out = get_tree().create_tween()
	fade_out.tween_property(self, "modulate", Color(1,1,1,0), 0.2)
	fade_out.set_trans(Tween.TRANS_QUART)
	fade_out.set_ease(Tween.EASE_IN_OUT)
	await fade_out.finished
	get_parent().queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
