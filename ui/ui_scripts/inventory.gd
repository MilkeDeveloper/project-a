extends PanelContainer


@onready var bag_container: GridContainer = $".."
@onready var item: TextureRect = $item
@export var stacks: Label
@export var item_data: ItemData

var preview_instance = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _get_drag_data(at_position: Vector2) -> Variant:
	set_drag_preview(get_preview())
	return item

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is TextureRect

func _drop_data(_pos: Vector2, data: Variant) -> void:
	var temp = item.texture
	item.texture = data.texture
	data.texture = temp
	
	var target_slot = get_item_slot(_pos)  # Tente encontrar o slot de destino
	if target_slot:
		var target_item = target_slot.get_node("item") if target_slot.has_node("item") else null
		if target_item:
			
			if target_item.texture == item.texture and item_data.stackable:
				# Atualiza a quantidade no slot de destino
				var target_stacks = target_slot.get_node("stacks") if target_slot.has_node("stacks") else null
				if target_stacks:
					target_stacks.text = str(int(target_stacks.text) + 1)
					item.texture = null  # Limpa o slot de origem
					stacks.text = "0"  # Limpa a pilha do slot de origem
					stacks.visible = false  # Esconde a pilha se for zero
	
func get_preview():
	var preview_tex = TextureRect.new()
	preview_tex.texture = item.texture
	preview_tex.expand_mode = 1
	preview_tex.size = Vector2(50, 50)
	
	var preview = Control.new()
	preview.size = Vector2(50, 50)
	preview.add_child(preview_tex)
	
	return preview

func get_item_slot(position: Vector2) -> Node:
	var slots = bag_container.get_children()  # Obtenha todos os slots
	for slot in slots:
		if slot.get_global_rect().has_point(position):
			return slot
	return null
	
