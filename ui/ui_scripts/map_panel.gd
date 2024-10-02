extends Control

@export var player_node: NodePath
var player

# Escala do mapa (5x menor)
var map_scale = 1.0 / 80

func _ready():
	player = get_node(player_node)
	
	# Escala o mapa
	$CenterContainer/MapBackground.scale = Vector2(map_scale, map_scale)
	
	# Centraliza o mapa dentro do painel
	$CenterContainer.anchor_right = 1.0
	$CenterContainer.anchor_bottom = 1.0
	self.visible = false  # Começa invisível

func _process(delta):
	if Input.is_action_just_pressed("map"):
		# Alterna a visibilidade do mapa
		self.visible = not self.visible
	if self.visible:
		update_player_position_on_map()

# Atualiza a posição do ícone do jogador no mapa
func update_player_position_on_map():
	var player_position = player.global_position
	var map_position = convert_world_to_map(player_position)
	$PlayerIcon.position = map_position

# Converte a posição global do jogador para a posição relativa no mapa
func convert_world_to_map(world_pos: Vector2) -> Vector2:
	var map_size = $CenterContainer/MapBackground.size  # Tamanho reduzido do mapa
	var world_size = Vector2(2600, 1300)  # Tamanho real do mundo
	var map_texture_pos = $CenterContainer/MapBackground.position  # Posição do mapa no painel

	# Calcula a posição escalada e adiciona a posição do mapa dentro do container
	return Vector2(
		(world_pos.x / world_size.x) * map_size.x + map_texture_pos.x,
		(world_pos.y / world_size.y) * map_size.y + map_texture_pos.y
	)
