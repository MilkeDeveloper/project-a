extends Sprite2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	modulate = Color(1.0, 1.0, 1.0, 0.5)

func _on_area_2d_body_exited(body: Node2D) -> void:
	modulate = Color(1.0, 1.0, 1.0, 1.0)
