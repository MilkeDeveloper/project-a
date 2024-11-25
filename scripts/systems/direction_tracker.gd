extends Node2D

class_name DirectionTracker
# Called when the node enters the scene tree for the first time.
@export var entity: CharacterBody2D

var direction = "down"

func _ready() -> void:
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_direction()

func get_direction():
	var velocity = get_velocity().normalized()
	var angle = velocity.angle()
	
	if entity.velocity == Vector2.ZERO:
		return direction
	
	if angle > -PI / 8 and angle <= PI / 8:
		direction = "right"
	elif angle > PI / 8 and angle <= 3 * PI / 8:
		direction = "down"
	elif angle > 3 * PI / 8 and angle <= 5 * PI / 8:
		direction = "down"
	elif angle > 5 * PI / 8 and angle <= 7 * PI / 8:
		direction = "down"
	elif angle > 7 * PI / 8 or angle <= -7 * PI / 8:
		direction = "left"
	elif angle > -7 * PI / 8 and angle <= -5 * PI / 8:
		direction = "up"
	elif angle > -5 * PI / 8 and angle <= -3 * PI / 8:
		direction = "up"
	elif angle > -3 * PI / 8 and angle <= -PI / 8:
		direction = "up"
	else:
		direction = "down"  # Valor padrão se nenhuma condição for atendida
	
	return direction
	
	
func get_action_direction(_target: Vector2):
	var my_direction = entity.global_position.direction_to(_target).normalized()
	var angle = my_direction.angle()
	
	if angle > -PI / 8 and angle <= PI / 8:
		direction = "right"
	elif angle > PI / 8 and angle <= 3 * PI / 8:
		direction = "right"
	elif angle > 3 * PI / 8 and angle <= 5 * PI / 8:
		direction = "down"
	elif angle > 5 * PI / 8 and angle <= 7 * PI / 8:
		direction = "left"
	elif angle > 7 * PI / 8 or angle <= -7 * PI / 8:
		direction = "left"
	elif angle > -7 * PI / 8 and angle <= -5 * PI / 8:
		direction = "left"
	elif angle > -5 * PI / 8 and angle <= -3 * PI / 8:
		direction = "up"
	elif angle > -3 * PI / 8 and angle <= -PI / 8:
		direction = "right"
	else:
		direction = "down"  # Valor padrão se nenhuma condição for atendida
	
	return direction
	
func get_velocity():
	return entity.velocity
