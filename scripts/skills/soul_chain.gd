extends Node2D

@export var totem_scene: PackedScene
@onready var select_area: Sprite2D = $select_area

var anim_direction
var mouse_position: Vector2
var skill_casted: bool
var _skill_damage: int
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	if is_inside_tree():
		anim_direction = get_parent().find_child("animation_component")
		select_area.hide()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	select_area.global_position = get_global_mouse_position()
	
	if Input.is_action_just_pressed("mouse_left"):
		mouse_position = get_global_mouse_position()
		GLobals.emit_signal("on_click")
		skill_casted = false
		select_area.hide()
		_handle_anim()
		spawn_totem()
		set_process(false)
		
func use_skill(_player, skill_damage, _cooldown, anim_component, target):
	if mouse_position != null:
		select_area.show()
		
	skill_casted = true
	_skill_damage = skill_damage
	player = _player
	set_process(true)
	
func spawn_totem():
	var totem_instance = totem_scene.instantiate()
	totem_instance.position = mouse_position
	totem_instance.damage_per_tick = (_skill_damage / 10) * randf_range(0.9, 0.8)
	totem_instance.explosion_damage = _skill_damage * randf_range(0.9, 0.8)
	totem_instance.attacker = player
	
	get_parent().get_parent().add_child(totem_instance)
	

func _handle_anim():
	player.get_node("anim").play("idle_" + player.get_node("DirectionTracker").get_action_direction(mouse_position))
