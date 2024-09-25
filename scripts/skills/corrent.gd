extends Node2D

# Variáveis para os objetos conectados
var totem: Node2D
var enemy: Node2D
var line: Line2D

var connected_enemy: Node2D  # Referência ao inimigo conectado

func _ready():
	line = $corrente
	update_line()
	
func _process(delta: float) -> void:
	if enemy == null:
		return
	update_line()
	
func update_line():
	# Verifique se totem e enemy estão definidos
	if totem and enemy:
		# Limpa os pontos anteriores
		line.clear_points()
		# Adiciona os novos pontos
		line.add_point(line.to_local(totem.global_position))
		line.add_point(line.to_local(enemy.global_position))

func set_connections(totem_ref: Node2D, enemy_ref: Node2D):
	print([totem_ref, enemy_ref])
	totem = totem_ref
	enemy = enemy_ref
	connected_enemy = enemy
	update_line()

func get_connected_enemy() -> Node2D:
	return connected_enemy
	
func remove_connections(totem_ref: Node2D, enemy_ref: Node2D):
	totem = totem_ref
	enemy = enemy_ref
	update_line()
