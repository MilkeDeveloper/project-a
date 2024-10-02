extends SubViewport

@export var player_ : CharacterBody2D
@export var point_map: Sprite2D
@export var container: SubViewportContainer

@export var player_node: NodePath
@export var map_background: NodePath  # Referência para o Node2D do mapa no Viewport
var player
var viewport_container

func _ready():
	player = player_
	# Definir o tamanho do viewport
	viewport_container = container
	# Definir o tamanho da janela que exibirá o mapa
	viewport_container.size = Vector2(800, 400)  # Tamanho da janela do mapa
	# Aplicar escala no ViewportContainer para reduzir o tamanho do conteúdo
	#viewport_container.scale = Vector2(1/5.0, 1/5.0)  # Escala 5x menor

func _process(delta):
		update_player_position_on_map()

# Atualiza a posição do ícone do jogador no mapa
func update_player_position_on_map():
	var player_position = player.global_position
	var map_position = convert_world_to_map(player_position)
	var player_icon = $point_map
	player_icon.position = map_position

# Converte a posição global do jogador para a posição relativa no mapa
func convert_world_to_map(world_pos: Vector2) -> Vector2:
	var world_size = Vector2(2600, 1300)  # Tamanho real do mundo
	var map_size = Vector2(2600, 1300)  # O mapa dentro do Viewport tem o tamanho real
	return Vector2(
		(world_pos.x / world_size.x) * map_size.x,
		(world_pos.y / world_size.y) * map_size.y
	)
