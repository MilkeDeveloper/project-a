extends Control

@export var inventory_container: GridContainer
@export var inventory: Inventory
@export var dragging_preview: TextureRect = null
@export var inventory_window: NinePatchRect
@export var discardItem_dialog: NinePatchRect
@export var discardItem_confirm: NinePatchRect
@export var anim: AnimationPlayer

var on_mouse_UI: bool = false
var mouse_position: Vector2
var index: int
var slot_index: int
var dragged_item: ItemData
var backup_item: ItemData
var quantity_to_discard: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dragging_preview.visible = false
	update_inventory()
	# Conectando o sinal ao adicionar um item
	ItemGlobals.connect("update_ui", on_item_added)
	ItemGlobals.connect("mouse_released", _on_mouse_released)
	ItemGlobals.connect("dragg_item", _on_draggin_item)
	ItemGlobals.connect("item_dragged_to_slot", _on_dragging_released)
	ItemGlobals.connect("send_discard", _on_discard_item)
	ItemGlobals.connect("update_category_ui", update_category_inventory)
	
	inventory.discard_area = Rect2(inventory_window.position, inventory_window.size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#update_inventory()
	if dragged_item != null:
		# Atualiza a posição da prévia para seguir o mouse
		dragging_preview.global_position = get_global_mouse_position() - dragging_preview.size / 2

# Atualiza a interface visual quando um item é adicionado
func update_inventory():
	# Limpa a interface
	for i in range(inventory_container.get_child_count()):
		var slot = inventory_container.get_child(i)
		var item_icon = slot.get_child(0)
		var item = inventory.general_slots[i]
		

		if item != null:
			# Exibe o ícone do item no slot
			item_icon.texture = item.icon
			
			# Exibe a quantidade, se o item for empilhável
			var label = item_icon.get_node("stack_label")
			#label.text = str(item.stacks) if item.stacks > 1 and item.stacks < item.max_stacks else ""
			if item.stacks >= item.max_stacks:
				label.text = str(item.max_stacks)
			else:
				label.text = str(item.stacks) if item.stacks > 1 else ""
		else:
			# Limpa o slot se estiver vazio
			item_icon.texture = null
			item_icon.get_node("stack_label").text = ""

func update_category_inventory(category: String):
	# Limpa a interface
	for i in range(inventory_container.get_child_count()):
		var slot = inventory_container.get_child(i)
		var item_icon = slot.get_child(0)
		var item = null
		match category:
			"general":
				item = inventory.general_slots[i]
			"equipment":
				item = inventory.equipment_slots[i]
			"consumable":
				item = inventory.consumable_slots[i]
			"material":
				item = inventory.material_slots[i]
			"etc":
				item = inventory.etc_slots[i]

		if item != null:
			# Exibe o ícone do item no slot
			item_icon.texture = item.icon
			
			# Exibe a quantidade, se o item for empilhável
			var label = item_icon.get_node("stack_label")
			#label.text = str(item.stacks) if item.stacks > 1 and item.stacks < item.max_stacks else ""
			if item.stacks >= item.max_stacks:
				label.text = str(item.max_stacks)
			else:
				label.text = str(item.stacks) if item.stacks > 1 else ""
		else:
			# Limpa o slot se estiver vazio
			item_icon.texture = null
			item_icon.get_node("stack_label").text = ""

# Função para ser chamada quando um item for adicionado ao inventário
func on_item_added():
	update_inventory()
	
func _on_draggin_item(new_index: int):
	var item_dragged = inventory.slots[new_index]
	
	if item_dragged != null:
		print("arrastando")
		dragged_item = item_dragged
		backup_item = item_dragged
		dragging_preview.texture = item_dragged.icon
		dragging_preview.visible = true
		slot_index = new_index
		
		for i in range(inventory_container.get_child_count()):
			var slot_item = inventory_container.get_child(new_index)
			slot_item.get_child(0).visible = false
		#dragged_item.icon = null

func _on_dragging_released(slot_index: int):
	dragging_preview.visible = false
	for i in range(inventory_container.get_child_count()):
		var slot_item = inventory_container.get_child(i)
		slot_item.get_child(0).visible = true
		update_inventory()
		
func _input(event: InputEvent) -> void:
	if event.is_action_released("mouse_left"):
		mouse_position = get_global_mouse_position()
		ItemGlobals.send_to_slot.emit(index, mouse_position)
		on_mouse_UI = false

func _on_mouse_released(slot_index):
	index = slot_index

func _on_mouse_entered() -> void:
	on_mouse_UI = true

func _on_discard_item(stackble: bool):
	if stackble:
		dragging_preview.visible = false
		anim.play("confirm_dialog_open")
		stackble = false
	else:
		dragging_preview.visible = false
		discardItem_dialog.visible = true
		discardItem_dialog.get_node("dialog").text = "Deseja destarcar o item?"
		anim.play("dialog_open")

func _on_accept_button_pressed() -> void:
	anim.play("dialog_close")
	ItemGlobals.receive_discard.emit(true, 1)


func _on_reject_button_pressed() -> void:
	anim.play("dialog_close")
	ItemGlobals.receive_discard.emit(false, 0)
	
func _on_discard_confirm_button_pressed():
	quantity_to_discard = int(discardItem_confirm.get_node("item_quantity").text)
	anim.play("confirm_dialog_close")
	ItemGlobals.receive_discard.emit(true, quantity_to_discard)


func _on_equipment_button_pressed() -> void:
	ItemGlobals.send_item_category.emit("equipment")


func _on_all_button_pressed() -> void:
	ItemGlobals.send_item_category.emit("general")


func _on_cosumable_button_pressed() -> void:
	ItemGlobals.send_item_category.emit("consumable")


func _on_material_button_pressed() -> void:
	ItemGlobals.send_item_category.emit("material")


func _on_etc_button_pressed() -> void:
	ItemGlobals.send_item_category.emit("etc")
