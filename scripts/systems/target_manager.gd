extends Node

class_name TargetManager

@export var max_target_distance: float

var targets: Array = []  # Lista de alvos disponíveis
var current_target: Node = null
var target_locked: bool = false
var detection_area: float

func _ready():
	set_process(false)
	update_target_list()
	await get_tree().create_timer(0.5).timeout
	set_process(true)

func _process(delta: float) -> void:
	update_target_list()
	

func update_target_list():
	
	targets.clear()  # Limpa a lista de alvos antes de atualizar
	
	var player_pos = get_parent().global_position  # Obtém a posição do jogador
	for entity in get_tree().get_nodes_in_group("targetables"):
		if entity.global_position.distance_to(player_pos) > 0 and entity.global_position.distance_to(player_pos) < 300:
			if entity is Targetable:
				targets.append(entity)


	if not target_locked:
		select_nearest_target()

func select_nearest_target():
	if targets.size() > 0 and not target_locked: 
		var nearest_disctance = max_target_distance
		for target in targets:
			var distance = target.global_position.distance_to(get_parent().global_position)
			if distance < nearest_disctance:
				nearest_disctance = distance
				current_target = target
				GLobals.target = current_target.get_parent()

			
				if GLobals.target != null:
					var _target = GLobals.target
					_target.get_node("target_area").set_hud_target()

func cycle_target():
	if targets.size() > 0 and targets != null:
		var index = targets.find(current_target)
		index = (index + 1) % targets.size()
		current_target = targets[index]
		GLobals.target = current_target.get_parent()
		
		if GLobals.target != null:
			var _target = GLobals.target
			_target.get_node("target_area").set_hud_target()

func lock_target():
	target_locked = true
	if GLobals.target != null:
		var _target = GLobals.target
		_target.get_node("target_area").set_hud_target()

func unlock_target():
	target_locked = false
	select_nearest_target()
