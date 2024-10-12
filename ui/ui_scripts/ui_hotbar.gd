extends Control

@export var inventory: Inventory
@export var item_hotbar: Array[ItemData]
@export var item: ItemData
@export var hotbar_container: HBoxContainer
@export var skill_manager: Node

var slot
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
	# Apenas para fins de teste
	_add_item_hotbar(item)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Função para adicionar um item à hotbar
func _add_item_hotbar(item: ItemData) -> bool:
	# Aqui percorremos a todos os slots da hotbar
	for i in range(item_hotbar.size()):
		slot = item_hotbar[i]
		# Caso o slot esteja vazio, adicionamos o item
		if slot == null:
			item_hotbar[i] = item
			update_ui()
			return true
	# Se todos os slots estão preenchidos a função não não adiciona nada
	print("Todos os slots já estão ocupados")
	# Aqui atualizamos a UI para refletir as mudanças na hotbar
	update_ui()
	return false # Hotbar cheia, não é possível adicionar mais itens

# Atualiza a interface da item hotbar
func update_ui():
	var h_slots = []
	# Percorre a lista de filhos do container para verificar quais são TextureButtons
	for i in range(hotbar_container.get_child_count()):
		if hotbar_container.get_child(i) is TextureButton:
			var textureB = hotbar_container.get_child(i)
			h_slots.append(textureB) # Se for um TextureButton, adiciona na lista de slots

	for n in range(h_slots.size()):
		# Aqui para cada TextureButton da lista de slots, verificamos se o botão tem um nó filho
		var n_slot = h_slots[n]
		if n_slot.get_child_count() > 0:
			var ui_item_hotbar = n_slot.get_child(0) # se ele tiver, então atribuimos esse nó filho à variável que será a textura
			
			var _item = null
			_item = item_hotbar[n] # Aqui atribuimos o item da hotbar física ao slot correspondente na UI
			# Esse bloco verifica se o slot da hotbar tem um item
			if _item != null:
				# Se ele tiver um item lá, atribuimos à textura do item para que seja mostrado visualmente na UI
				if ui_item_hotbar.texture == null:
					ui_item_hotbar.texture = _item.icon



func _on_texture_button_pressed() -> void:
	print("usando o item do slot 1")
