extends PanelContainer


signal item_clicked(slot)

@export var item: TextureRect
@export var stacks: Label

# Função que emite o sinal quando o slot é clicado
func _on_item_clicked(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("item_clicked", self)
		print("signal emited")
