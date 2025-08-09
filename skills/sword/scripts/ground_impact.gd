extends SkillBase

class_name GroundImpact

@export var height: float
@export var air_time: float
@export var fall_time: float
@export var travel_time: float
@export var range: float

var target_pos: Vector2
var desired_position: Vector2
var current_position: Vector2
var position_seted: Vector2
var is_path: bool = false

func _ready() -> void:
	set_process(false)

func _process(delta: float) -> void:
	selector.global_position = get_global_mouse_position()
	current_position = global_position
	if Input.is_action_just_pressed("cancel"):
		queue_free()
	
	if player.global_position.distance_to(selector.global_position) > range:
		selector.modulate = Color(1,0,0,0.7)
		if Input.is_action_just_released("hotbar_3"):
			queue_free()
	else: 
		selector.modulate = Color(0.281, 0.78, 0.697, 0.89)
		position_seted = get_global_mouse_position()
		if Input.is_action_just_released("hotbar_3"):
			
			selector.hide()
			start_jump()
			GLobals.emit_signal("on_click")
				
			queue_free()
	
	if player.global_position.distance_to(position_seted) <= 15 and is_path:
		is_path = false
		

func use_skill(_player, skill_damage, _cooldown, target, _cast_time = null):
	player = _player
	target_pos = get_global_mouse_position()

	if player.global_position.distance_to(target_pos) > range:
		var dir = player.global_position.direction_to(target_pos).normalized()
		target_pos = player.global_position + dir * range

	desired_position = target_pos
	selector.show()
	set_process(true)
	

func start_jump():
	is_path = true

	var fsm = player.get_node("StateMachineManager")
	fsm.change_state("SkillState", {"skill": SkillState.Skills.R, "target_pos": position_seted})
	await  get_tree().create_timer(1.0).timeout
	queue_free()
