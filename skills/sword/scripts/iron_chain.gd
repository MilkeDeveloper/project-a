extends SkillBase

@export var max_distance := 300.0
@export var speed := 600.0
@export var slow_duration := 1.5
@export var slow_amount := 0.5

var attacker: CharacterBody2D
var hit := false
var target: Node2D
var direction := Vector2.ZERO
var distance_travelled := 0.0
var reeling_back := false
var start_pos: Vector2
var extending: bool = true

@onready var line := $chain
@onready var sprite := $sprite
#@onready var shape := $Area2D/CollisionShape2D
@onready var timer := $duration

func _ready():
	line.clear_points()
	start_pos = global_position
	line.clear_points()
	line.add_point(Vector2.ZERO)  # Ponto inicial
	line.add_point(Vector2.ZERO)  # Ponto que vai sendo estendido
	timer.connect("timeout", Callable(self, "_on_timeout"))
	
	set_process(false)

func use_skill(_player, _damage, _cooldown, anim_component, _target = null):
	damage = _damage
	attacker = _player
	launch(global_position.direction_to(get_global_mouse_position()))
	set_process(true)

func launch(_direction: Vector2):
	direction = _direction.normalized()
	sprite.rotation = direction.angle()
	timer.start(1.0)  # tempo máximo de voo

func _process(delta):
	if extending:
		var step = speed * delta
		distance_travelled += step

		if distance_travelled >= max_distance:
			distance_travelled = max_distance
			start_reeling()
		
		var end_pos = direction * distance_travelled
		line.set_point_position(1, end_pos)

		# Atualiza posição da ponta (Area2D e Sprite)
		var tip_global = start_pos + end_pos
		sprite.global_position = tip_global
		#$Sprite2D.global_position = tip_global

	elif reeling_back:
		var step = speed * delta
		distance_travelled -= step

		if distance_travelled <= 0:
			queue_free()
			return

		var end_pos = direction * distance_travelled
		line.set_point_position(1, end_pos)

		var tip_global = start_pos + end_pos
		sprite.global_position = tip_global
		#$Sprite2D.global_position = tip_global
	elif hit:
		var target_pos = (target.global_position - global_position).normalized()
		var step = speed * delta
		var distance = global_position.distance_to(target_pos)
		distance -= step

		if global_position.distance_to(target_pos) <= 0:
			queue_free()
			return

		var end_pos = target_pos
		line.set_point_position(1, end_pos)

		var tip_global = start_pos + end_pos
		sprite.global_position = tip_global
		
func start_reeling():
	extending = false
	reeling_back = true
	hit = false

func start_grab():
	extending = false
	reeling_back = false
	hit = true
	

func _pull_target(target_to_grab: Node2D):
	var _direction = (target_to_grab.global_position - get_parent().global_position).normalized()
	var offset = _direction * 25
	var tween := create_tween()
	tween.tween_property(target_to_grab, "global_position", get_parent().global_position + offset , 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.connect("finished", Callable(self, "_on_pull_complete"))

func _on_pull_complete():
	queue_free()

func _on_timeout():
	if not hit:
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	target = body
	
	if hit:
		return
	
	if body.has_method("apply_status"):
		pass
		#body.apply_status("slowed", slow_amount, slow_duration)
		
	if body.is_in_group("entity") and body.has_method("take_damage"):
		start_grab()
		body.take_damage(damage, attacker, body, "magic_hit")
		_pull_target(body)
