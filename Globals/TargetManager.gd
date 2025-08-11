extends Node

# Guarda o ID do NPC que tá selecionado como alvo
var current_target_id: String = ""

# Dicionário com referência aos NPCs vivos no mapa (map_npc_id -> nodo do NPC)
var npc_registry := {}

func register_npc(npc: NPCBase):
	# O spawnner chama isso antes de spawnnar o npc garantindo que ele não nasça sem um ID de mapa
	npc_registry[npc.map_npc_id] = npc

func unregister_npc(npc: NPCBase):
	# Quando NPC morre/desaparece
	if npc_registry.has(npc.map_npc_id):
		npc_registry.erase(npc.map_npc_id)
	if current_target_id == npc.map_npc_id:
		clear_target()

func set_target(npc_id: String):
	if current_target_id == npc_id:
		return # já é o alvo

	# Desmarca alvo anterior
	if npc_registry.has(current_target_id):
		npc_registry[current_target_id].clear_target()

	current_target_id = npc_id

	# Marca novo alvo
	if npc_registry.has(current_target_id):
		npc_registry[current_target_id].set_as_target()
	else:
		print("TargetManager: NPC com ID %s não encontrado." % npc_id)

func clear_target():
	if npc_registry.has(current_target_id):
		npc_registry[current_target_id].clear_target()
	current_target_id = ""

func get_current_target():
	if current_target_id != "":
		return npc_registry.get(current_target_id, null)
	return null
