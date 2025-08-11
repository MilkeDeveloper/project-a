extends Marker2D

@export var npc_info: NPCSpawnInfo
@export var npc_quantity: int

var spawn_status: String
var id_counter: int = 0
var npc_id: String

func spawn_npc(position: Vector2):
	if not npc_info.data:
		push_error("Nenhum NpcData definido!")
		spawn_status = "spawn_fail"
		return
	
	var npc: NPCBase = npc_info.npc_scene.instantiate()
	npc.position = position + Vector2(randf_range(-50, 50), randf_range(-50, 50))
	npc.scale.x = 0.3
	npc.scale.y = 0.3

	generate_map_npc_id(npc)
	register_npc(npc)


	# Adiciona IA se existir
	if npc_info.data.ai_behavior and npc_info.data.ai_behavior.ai_behavior:
		var ai = npc_info.data.ai_behavior.ai_behavior.instantiate()
		if npc.has_node("AIController"):
			npc.get_node("AIController").add_child(ai)
		else:
			npc.add_child(ai)

	get_parent().add_child.call_deferred(npc)
	spawn_status = "spawn_successful"

	return npc

func _ready():
	# Exemplo: spawna um NPC na posição (300, 200)
	for x in npc_quantity:
		spawn_npc(self.global_position)
	
		if spawn_status == "spawn_successful":
			print("O npc " + npc_info.data.npc_name + " foi spawnado com o ID: " + npc_id)
		else:
			print("Houve um erro ao tentar spawnar o npc!")
	

func generate_map_npc_id(npc: NPCBase):
	if npc == null:
		return
	# Gera um id para o NPC no mapa
	id_counter += 1
	npc.map_npc_id = "MAP_NPC_" + str(id_counter)
	npc_id = npc.map_npc_id

func register_npc(npc: NPCBase):
	if npc == null:
		return
	# Registra o npc no TargetManager
	TargetManager.register_npc(npc)
	print("Npc [" + npc_info.data.npc_name + "] com ID [" + npc_id + "] foi registrado.")
