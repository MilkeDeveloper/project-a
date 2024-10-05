extends Node


#signals
signal item_pickup(item: ItemData, quantity: int)
signal update_ui

#control vars
var collected: bool
