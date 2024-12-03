extends Node2D


class_name Targetable

var is_targetable: bool = true  # Pode ser alvo
var distance_to_player: float = INF  # Atualizado dinamicamente

func calculate_distance_to_player(player_pos: Vector2):
	if is_targetable:
		distance_to_player = global_position.distance_to(player_pos)
