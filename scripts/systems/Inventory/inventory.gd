extends Control

@export var inventory_container: GridContainer
@export var inventory: Inventory
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_inventory()
	# Conectando o sinal ao adicionar um item
	ItemGlobals.connect("update_ui", on_item_added)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#update_inventory()
	pass

# Atualiza a interface visual quando um item é adicionado
func update_inventory():
	# Limpa a interface
	for i in range(inventory_container.get_child_count()):
		var slot = inventory_container.get_child(i)
		var item_icon = slot.get_child(0)
		var item = inventory.item_slots[i]

		if item != null:
			# Exibe o ícone do item no slot
			item_icon.texture = item.icon
			# Exibe a quantidade, se o item for empilhável
			var label = item_icon.get_node("stack_label")
			#label.text = str(item.stacks) if item.stacks > 1 and item.stacks < item.max_stacks else ""
			if item.stacks >= item.max_stacks:
				label.text = str(item.max_stacks)
			else:
				label.text = str(item.stacks)
		else:
			# Limpa o slot se estiver vazio
			item_icon.texture = null
			item_icon.get_node("stack_label").text = ""

# Função para ser chamada quando um item for adicionado ao inventário
func on_item_added():
	update_inventory()
