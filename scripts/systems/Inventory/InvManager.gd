extends Resource

class_name Inventory

@export var max_slots: int = 40
@export var general_slots: Array[ItemData]
@export var equipment_slots: Array[ItemData]
@export var consumable_slots: Array[ItemData]
@export var material_slots: Array[ItemData]
@export var etc_slots: Array[ItemData]


var remainng_items: int
var has_remaining: bool = false
var interactions: int = 1
var is_dragging: bool = false
var dragged_item: ItemData
var index_from_dragg: int
var discarded_items: int

var discard_area: Rect2 # Define a área do inventário para comparação
var slots = general_slots
var item_category: String = "general"

var current_category: String = "general"

func _init():
	# Inicializar os slots com nulos (slots vazios)
	general_slots.resize(max_slots)
	for i in range(max_slots):
		general_slots[i] = null
		
	ItemGlobals.connect("item_pickup", _on_item_received)
	ItemGlobals.connect("send_slot", _on_slot_clicked)
	ItemGlobals.connect("send_to_slot", _on_slot_released)
	ItemGlobals.connect("receive_discard", _on_discard_item)
	ItemGlobals.connect("send_item_category", get_items_by_category)

# Função para adicionar um item ao inventário
func _add_item(item_data: ItemData, item_quantity: int, category: String) -> bool:

	print(interactions)
	for i in range(general_slots.size()):
		var current_item = general_slots[i]
		
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
					if current_category == "general":
						ItemGlobals.emit_signal("update_ui")
					else:
						ItemGlobals.emit_signal("update_category_ui", current_category)
					return true  # Todo o item foi adicionado
				else:
					# Se os stacks por slot cehgaram ao máximo continua para adicionar o que sobrou no próximo slot que estiver vazio
					continue
	
	# Percorre todos os slots e verifica se o slot está vazio, então adiciona o resto dos items que sobraram do slot anterior
	for i in range(general_slots.size()):
		var current_item = general_slots[i]
		if has_remaining and current_item == null: 
			print("itens restantes: " + str(remainng_items))
			var new_item = item_data.duplicate()  # Cria uma cópia do item
			general_slots.append(new_item)  # Adiciona ao inventário
			general_slots[i] = new_item
			general_slots[i].stacks =  remainng_items
			print("adicionando " + general_slots[i].item_name + " " + str(remainng_items + item_quantity))
			# Atualiza a UI do inventario
			if current_category == "general":
				ItemGlobals.emit_signal("update_ui")
			else:
				ItemGlobals.emit_signal("update_category_ui", current_category)
			
			remainng_items = 0
			return true
	
	# Verifica se o slot está vazio, então adiciona o item nesse slot
	for i in range(general_slots.size()):
		var current_item = general_slots[i]
		if current_item == null:
			general_slots[i] = item_data
			general_slots[i].stacks += item_quantity
			print("adicionando " + general_slots[i].item_name + " " + str(item_quantity))
			# Atualiza a UI do inventario
			if current_category == "general":
				ItemGlobals.emit_signal("update_ui")
			else:
				ItemGlobals.emit_signal("update_category_ui", current_category)
			
			#interactions += 1
	
			return true  # Continua para o próximo loop

	return false  # Inventário cheio ou não foi possível adicionar

func _add_item_by_category(item_data: ItemData, item_quantity: int, category: String) -> bool:
	
	match category:
		"general":
			slots = general_slots
		"equipment":
			slots = equipment_slots
		"consumable":
			slots = consumable_slots
		"material":
			slots = material_slots
		"etc":
			slots = etc_slots
	
	for i in range(slots.size()):
		var current_item = slots[i]
		
		# Verifica se é o mesmo item e se pode empilhar
		if current_item != null and current_item.item_name == item_data.item_name and current_item.stacks < current_item.max_stacks and current_item.stackable == true:
			if item_data.stacks >= 0:
				current_item.stacks = current_item.stacks
				print("item stackble: " + str(current_item.item_name) + " + " + str(item_quantity))
				print(str(current_item.item_name) + ": " + str(current_item.stacks))
				
				# Verifica se a quantidade de itens ultrapassa o maximo do items por slot, então calcula o resto para adicionar ao novo slot
				if current_item.stacks >= current_item.max_stacks:
					remainng_items = current_item.stacks - current_item.max_stacks
					has_remaining = true
				# verifica se sobrou item
				if remainng_items <= 0:
					# Atualiza a UI do inventario
					if current_category == "general":
						ItemGlobals.emit_signal("update_ui")
					else:
						ItemGlobals.emit_signal("update_category_ui", current_category)
					return true  # Todo o item foi adicionado
				else:
					# Se os stacks por slot cehgaram ao máximo continua para adicionar o que sobrou no próximo slot que estiver vazio
					continue
	
	# Percorre todos os slots e verifica se o slot está vazio, então adiciona o resto dos items que sobraram do slot anterior
	for i in range(slots.size()):
		var current_item = slots[i]
		if has_remaining and current_item == null: 
			print("itens restantes: " + str(remainng_items))
			var new_item = item_data.duplicate()  # Cria uma cópia do item
			slots[i].append(new_item)  # Adiciona ao inventário
			slots[i] = new_item
			slots[i].stacks =  remainng_items
			print("adicionando " + slots[i].item_name + " " + str(remainng_items + item_quantity))
			# Atualiza a UI do inventario
			if current_category == "general":
				ItemGlobals.emit_signal("update_ui")
			else:
				ItemGlobals.emit_signal("update_category_ui", current_category)
			remainng_items = 0
			return true
	
	# Verifica se o slot da categoria do item está vazio, então adiciona o item nesse slot
	for i in range(slots.size()):
		var actual_item = slots[i]
		if actual_item == null:
			slots[i] = item_data
			slots[i].stacks = slots[i].stacks
			print("adicionando " + slots[i].item_name + " " + str(item_quantity))
			# Atualiza a UI do inventario
			if current_category == "general":
				ItemGlobals.emit_signal("update_ui")
			else:
				ItemGlobals.emit_signal("update_category_ui", current_category)
			interactions += 1
		
			return true  # Item adicionado com sucesso

	return false  # Inventário cheio ou não foi possível adicionar

func get_items_by_category(category: String):
	current_category = category
	match category:
		"general":
			slots = general_slots
			ItemGlobals.emit_signal("update_category_ui", current_category)
		"equipment":
			slots = equipment_slots
			ItemGlobals.emit_signal("update_category_ui", current_category)
		"consumable":
			slots = consumable_slots
			item_category = "consumable"
			ItemGlobals.emit_signal("update_category_ui", current_category)
		"material":
			slots = material_slots
			item_category = "material"
			ItemGlobals.emit_signal("update_category_ui", current_category)
		"etc":
			slots = etc_slots
			item_category = "etc"
			ItemGlobals.emit_signal("update_category_ui", current_category)
			
	return current_category

# Recebe o item coletado
func _on_item_received(itemData: ItemData, quantity: int, category: String):
	# Adiciona o item recebido ao iventário
	_add_item(itemData, quantity, itemData.item_category)
	_add_item_by_category(itemData, quantity, itemData.item_category)
	get_items_by_category("general")

# Verifica se houve um click no slot, então pega o index do slot para mover o item de lugar
func _on_slot_clicked(slot_index: int):
	if slots[slot_index] != null:
		if slots[slot_index].item_name != null:
			index_from_dragg = slot_index  # Salva o índice do slot de origem
			dragged_item = slots[slot_index]  # Salva o item a ser arrastado
			is_dragging = true
			ItemGlobals.dragg_item.emit(slot_index)  # Emite o sinal de item arrastado
			ItemGlobals.update_category_ui.emit(current_category)  # Atualiza a UI
			slots[slot_index] = null  # Remove o item do slot original (temporariamente)
			print("dragging item")

# Quando o item é solto em um novo slot
func _on_slot_released(index: int, screen_mouse_position: Vector2):
	var mouse_position = screen_mouse_position
	if is_in_discard_area(mouse_position) and is_dragging:
		# O item foi arrastado para fora do inventário, descartar
		if dragged_item.stackable and dragged_item.stacks > 1:
			print("Item discarded")
			is_dragging = false
			ItemGlobals.send_discard.emit(true)
			ItemGlobals.update_ui.emit()  # Atualiza a UI para refletir que o item foi removido
		else:
			print("Item discarded")
			is_dragging = false
			ItemGlobals.send_discard.emit(false)
			ItemGlobals.update_ui.emit()  # Atualiza a UI para refletir que o item foi removido
	
	elif is_valid_slot(index) and slots[index] == null and is_dragging:
		# Solta o item no novo slot
		slots[index] = dragged_item
		is_dragging = false
		dragged_item = null
		
		# Atualiza a UI para refletir a mudança visual
		ItemGlobals.item_dragged_to_slot.emit(index)
		ItemGlobals.update_category_ui.emit(current_category)
		print("dragged: " + slots[index].item_name)
	else:
		# Caso o slot já esteja ocupado, troca de lugar com o item no slot de origem
		if is_valid_slot(index) and is_dragging:
			general_slots[index_from_dragg] = general_slots[index]
			general_slots[index] = dragged_item
			is_dragging = false
			dragged_item = null
			# Atualiza a UI para mostrar que o item não foi movido
			ItemGlobals.item_dragged_to_slot.emit(index)
			ItemGlobals.update_ui.emit()
			print("dragging canceled, restored to original slot")

func is_valid_slot(index: int) -> bool:
	# Verifica se o índice do slot está dentro dos limites do inventário
	if slots != null:
		return index >= 0 and index < slots.size()
	return false

# Verifica se o item foi arrastado para fora do inventário
func is_in_discard_area(mouse_position: Vector2) -> bool:
	return not discard_area.has_point(mouse_position)

func _on_discard_item(discard: bool, quantity: int):
	if discard and quantity < dragged_item.stacks:
		general_slots[index_from_dragg] = dragged_item
		general_slots[index_from_dragg].stacks -= quantity
		dragged_item = null
		print("O item foi descartado com sucesso!")
		ItemGlobals.update_ui.emit()
		ItemGlobals.item_dragged_to_slot.emit(index_from_dragg)
	elif discard and quantity >= dragged_item.stacks:
		general_slots[index_from_dragg] = dragged_item
		general_slots[index_from_dragg].stacks = 0
		general_slots[index_from_dragg] = null
		dragged_item = null
		print("O item foi descartado com sucesso!")
		ItemGlobals.update_ui.emit()
		ItemGlobals.item_dragged_to_slot.emit(index_from_dragg)
	else:
		general_slots[index_from_dragg] = dragged_item
		is_dragging = false
		dragged_item = null
		ItemGlobals.item_dragged_to_slot.emit(index_from_dragg)
		ItemGlobals.update_ui.emit()
