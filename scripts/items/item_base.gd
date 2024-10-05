extends Sprite2D

class_name ItemBase

@export var item_data: ItemData

@export var quantity: int = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture = item_data.icon


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("send item")
		ItemGlobals.emit_signal("item_pickup", item_data, quantity)
		call_deferred("queue_free")
