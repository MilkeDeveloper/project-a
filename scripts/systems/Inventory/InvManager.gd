extends Resource

class_name Inventory

@export var max_slots: int = 40
@export var item_slots: Array[ItemData]

var remainng_items: int
var has_remaining: bool = false
var interactions: int = 1
var is_dragging: bool = false
var dragged_item: ItemData
var index_from_dragg: int

var discard_area: Rect2  # Define a área do inventário para comparação

func _init():
	# Inicializar os slots com nulos (slots vazios)
	item_slots.resize(max_slots)
	for i in range(max_slots):
		item_slots[i] = null
		
	ItemGlobals.connect("item_pickup", _on_item_received)
	ItemGlobals.connect("send_slot", _on_slot_clicked)
	ItemGlobals.connect("send_to_slot", _on_slot_released)
	ItemGlobals.connect("receive_discard", _on_discard_item)
	
	
	# Defina a área de descarte com base na posição e no tamanho da sua UI do inventário
	

# Função para adicionar um item ao inventário
func _add_item(item_data: ItemData, item_quantity: int) -> bool:
	print(interactions)
	for i in range(item_slots.size()):
		var current_item = item_slots[i]
		
		# Verifica se é o mesmo item e se pode empilhar
		if current_item != null and current_item.item_name == item_data.item_name and current_item.stacks < current_item.max_stacks and current_item.stackable == true:
			if item_data.stacks >= 0:
				current_item.stacks += item_quantity
				print("item stackble: " + str(current_item.item_name) + " + " + str(item_quantity))
				print(str(current_item.item_name) + ": " + str(current_item.stacks))
				
				# Verifica se a quantidade de itens ultrapassa o maximo do items por slot, então calcula o resto para adicionar ao novo slot
				if current_item.stacks >= current_item.max_stacks:
					remainng_items = current_item.stacks - current_item.max_stacks
					has_remaining = true
				# verifica se sobrou item
				if remainng_items <= 0:
					# Atualiza a UI do inventario
					ItemGlobals.emit_signal("update_ui")
					return true  # Todo o item foi adicionado
				else:
					# Se os stacks por slot cehgaram ao máximo continua para adicionar o que sobrou no próximo slot que estiver vazio
					continue
	
	# Percorre todos os slots e verifica se o slot está vazio, então adiciona o resto dos items que sobraram do slot anterior
	for i in range(item_slots.size()):
		var current_item = item_slots[i]
		if has_remaining and current_item == null: 
			print("itens restantes: " + str(remainng_items))
			var new_item = item_data.duplicate()  # Cria uma cópia do item
			item_slots.append(new_item)  # Adiciona ao inventário
			item_slots[i] = new_item
			item_slots[i].stacks =  remainng_items
			print("adicionando " + item_slots[i].item_name + " " + str(remainng_items + item_quantity))
			# Atualiza a UI do inventario
			ItemGlobals.emit_signal("update_ui")
			remainng_items = 0
			return true
	
	# Verifica se o slot está vazio, então adiciona o item nesse slot
	for i in range(item_slots.size()):
		var current_item = item_slots[i]
		if current_item == null:
			item_slots[i] = item_data
			item_slots[i].stacks += item_quantity
			print("adicionando " + item_slots[i].item_name + " " + str(item_quantity))
			# Atualiza a UI do inventario
			ItemGlobals.emit_signal("update_ui")
			interactions += 1
	
			return true  # Item adicionado com sucesso

	return false  # Inventário cheio ou não foi possível adicionar

# Recebe o item coletado
func _on_item_received(itemData: ItemData, quantity: int):
	# Adiciona o item recebido ao iventário
	_add_item(itemData, quantity)

# Verifica se houve um click no slot, então pega o index do slot para mover o item de lugar
func _on_slot_clicked(slot_index: int):
	if item_slots[slot_index] != null:
		if item_slots[slot_index].item_name != null:
			index_from_dragg = slot_index  # Salva o índice do slot de origem
			dragged_item = item_slots[slot_index]  # Salva o item a ser arrastado
			is_dragging = true
			ItemGlobals.dragg_item.emit(slot_index)  # Emite o sinal de item arrastado
			ItemGlobals.update_ui.emit()  # Atualiza a UI
			item_slots[slot_index] = null  # Remove o item do slot original (temporariamente)
			print("dragging item")

# Quando o item é solto em um novo slot
func _on_slot_released(index: int, screen_mouse_position: Vector2):
	var mouse_position = screen_mouse_position
	if is_in_discard_area(mouse_position) and is_dragging:
		# O item foi arrastado para fora do inventário, descartar
		print("Item discarded")
		is_dragging = false
		ItemGlobals.send_discard.emit()
		ItemGlobals.update_ui.emit()  # Atualiza a UI para refletir que o item foi removido
	
	elif is_valid_slot(index) and item_slots[index] == null and is_dragging:
		# Solta o item no novo slot
		item_slots[index] = dragged_item
		is_dragging = false
		dragged_item = null
		
		# Atualiza a UI para refletir a mudança visual
		ItemGlobals.item_dragged_to_slot.emit(index)
		ItemGlobals.update_ui.emit()
		print("dragged: " + item_slots[index].item_name)
	else:
		# Caso o slot já esteja ocupado, troca de lugar com o item no slot de origem
		if is_valid_slot(index) and is_dragging:
			item_slots[index_from_dragg] = item_slots[index]
			item_slots[index] = dragged_item
			is_dragging = false
			dragged_item = null
			# Atualiza a UI para mostrar que o item não foi movido
			ItemGlobals.item_dragged_to_slot.emit(index)
			ItemGlobals.update_ui.emit()
			print("dragging canceled, restored to original slot")

func is_valid_slot(index: int) -> bool:
	# Verifica se o índice do slot está dentro dos limites do inventário
	return index >= 0 and index < item_slots.size()

# Verifica se o item foi arrastado para fora do inventário
func is_in_discard_area(mouse_position: Vector2) -> bool:
	return not discard_area.has_point(mouse_position)

func _on_discard_item(discard: bool):
	if discard:
		is_dragging = false
		dragged_item = null
		print("O item foi descartado com sucesso!")
		ItemGlobals.update_ui.emit()
		ItemGlobals.item_dragged_to_slot.emit(index_from_dragg)
	else:
		item_slots[index_from_dragg] = dragged_item
		is_dragging = false
		dragged_item = null
		ItemGlobals.item_dragged_to_slot.emit(index_from_dragg)
		ItemGlobals.update_ui.emit()
