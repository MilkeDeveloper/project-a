extends Resource

class_name Inventory

@export var max_slots: int = 28
@export var item_slots: Array[ItemData]

var remainng_items: int
var has_remaining: bool = false
var interactions: int = 1

func _init():
	# Inicializar os slots com nulos (slots vazios)
	item_slots.resize(max_slots)
	for i in range(max_slots):
		item_slots[i] = null
		
	ItemGlobals.connect("item_pickup", _on_item_received)

# Função para adicionar um item ao inventário
func _add_item(item_data: ItemData, item_quantity: int) -> bool:
	print(interactions)
	for i in range(item_slots.size()):
		var current_item = item_slots[i]
		# Verifica se o slot está vazio
		if current_item == null:
			if has_remaining: 
				print("itens restantes: " + str(remainng_items))
				var new_item = item_data.duplicate()  # Cria uma cópia do item
				item_slots.append(new_item)  # Adiciona ao inventário
				item_slots[i] = new_item
				item_slots[i].stacks =  item_quantity + remainng_items
				print("adicionando " + item_slots[i].item_name + " " + str(remainng_items + item_quantity))
			else:
				item_slots[i] = item_data
				item_slots[i].stacks += item_quantity
				print("adicionando " + item_slots[i].item_name + " " + str(item_quantity))
				
			print("item: " + str(item_slots[i].item_name) + " + " + str(item_quantity))
			ItemGlobals.emit_signal("update_ui")
			interactions += 1
	
			return true  # Item adicionado com sucesso
			
		# Verifica se é o mesmo item e se pode empilhar
		elif current_item.item_name == item_data.item_name and current_item.stacks < current_item.max_stacks and current_item.stackable == true:
			if item_data.stacks >= 0:
				current_item.stacks += item_quantity
				print("item stackble: " + str(current_item.item_name) + " + " + str(item_quantity))
				print(str(current_item.item_name) + ": " + str(current_item.stacks))
				
				# Verifica se a quantidade de itens ultrapassa o maximo do items por slot, então calcula o resto para adicionar ao novo slot
				if current_item.stacks >= current_item.max_stacks:
					remainng_items = current_item.stacks - current_item.max_stacks
					has_remaining = true
					
				ItemGlobals.emit_signal("update_ui")
				return true  # Todo o item foi adicionado

	return false  # Inventário cheio ou não foi possível adicionar


func _on_item_received(itemData: ItemData, quantity: int):
	# Adiciona o item recebido ao iventário
	_add_item(itemData, quantity)
