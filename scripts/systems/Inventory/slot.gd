extends TextureButton

@export var slot_index: int

var index

func _on_button_down() -> void:
	ItemGlobals.send_slot.emit(slot_index)



func _on_mouse_entered() -> void:
	ItemGlobals.mouse_released.emit(slot_index)
