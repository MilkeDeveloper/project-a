extends SkillBase

@export var max_distance: float = 300.0
@export var step: float = 16.0  # espaço entre cada ponto (ajustável)
@export var speed: float

@export var VFX: PackedScene
#Para o efeito de knockup
@export_category("Knockup Effect")
@export var status_vars: Dictionary

var crack_line: Line2D

var particles: Node2D
var direction: Vector2  # direção com base na rotação da skill
var entity: Node2D
@onready var area = $Area2D

func use_skill(_player, _damage, _cooldown, anim_component, _target = null):
	damage = _damage
	entity = _player
	
	direction = (get_global_mouse_position() - global_position).normalized()
	_player.use_skill = true
	_player.get_node("StateMachineManager").change_state("SkillState", {"skill": SkillState.Skills.E1})
	await get_tree().create_timer(0.5)
	spawn_crack_effect(direction)
	
	
func spawn_crack_effect(direction: Vector2):
	var distance := 0.0
	particles = VFX.instantiate()
	get_tree().current_scene.add_child(particles)
	
	crack_line = particles.get_node("crack_line")
	particles.global_position = global_position  # fixa no mapa, ponto inicial
	
	while distance < max_distance:
		var local_point := direction.normalized() * distance
		crack_line.add_point(local_point)
		
		# Emitir partículas em cada ponto
		var detritos = particles.get_node("detritos")
		var smoke = particles.get_node("smoke")
		var energy = particles.get_node("energy")
		
		detritos.global_position = particles.global_position + local_point
		smoke.global_position = detritos.global_position
		energy.global_position = detritos.global_position
		area.global_position = energy.global_position
		
		detritos.emitting = true
		smoke.emitting = true
		energy.emitting = true

		distance += step
		await get_tree().create_timer(0.02).timeout
		detritos.emitting = false
		smoke.emitting = false
		energy.emitting = false

	area.queue_free()
	await get_tree().create_timer(7.5).timeout
	clear_effect()
	
	
func _apply_damage_and_status(body):
	if body.is_in_group("entity"):
		if body.has_method("take_damage"):
			body.take_damage(damage, entity, body, "magic_hit")

		if body.has_method("apply_status"):
			body.apply_status(body, status_vars)

func clear_effect():
	var tween := get_tree().create_tween()
	
	tween.tween_property(crack_line, "modulate", Color(1,1,1,0), 2.5)


func _on_area_2d_body_entered(body: Node2D) -> void:
	_apply_damage_and_status(body)
