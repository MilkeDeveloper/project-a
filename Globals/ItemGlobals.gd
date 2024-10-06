extends Node


# inventory signals
signal item_pickup(item: ItemData, quantity: int)
signal update_ui
signal send_slot(slot_index: int)
signal send_to_slot(index: int, screen_mouse_position: Vector2)
signal mouse_released(slot_index: int)
signal dragg_item(slot_index: int)
signal item_dragged_to_slot(slot_index: int)
signal send_discard(stackble: bool)
signal receive_discard(discard: bool, quantity: int)

#control vars
var collected: bool
var is_dragging: bool = false
