extends Node2D

@export var Projectile: PackedScene
@onready var select_area: Sprite2D = $Sprite2D

var anim_direction
var skill_manager
var skill_cooldown
var arrows_sequence = 1
var time_between_arrows = 0.4
var player
var used_skill
var mouse_position
var is_on_cooldown
var skill_dmg



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	set_process(false)
	if is_inside_tree():
		anim_direction = get_parent().find_child("animation_component")
		select_area.hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	select_area.global_position = get_global_mouse_position()
	
		
	if used_skill and Input.is_action_just_pressed("mouse_left"):
		GLobals.emit_signal("on_click")
		used_skill = false
		select_area.hide()
		mouse_position = get_global_mouse_position()
		for arrow in arrows_sequence:
			var projectile = Projectile.instantiate()
			projectile.global_position = player.global_position
			projectile.direction = get_direction()
			#projectile.mouse_position = mouse_position
			projectile.damage = randi_range((skill_dmg * 0.8), skill_dmg )
			projectile.attacker = player
			projectile.target_position = mouse_position
			projectile.speed_duration = 300
			projectile.origin_position = player.global_position
			_handle_anim()
			get_parent().get_parent().add_child(projectile)
			#projectile.get_node("animation")._on_animate_fireball()
			projectile.launch_fireball(mouse_position, 500)
			await get_tree().create_timer(time_between_arrows).timeout
			
		set_process(false)
	
func use_skill(node, damage, _cooldown, anim_component, _target = null):
	skill_dmg = damage
	skill_cooldown = _cooldown
	player = node
	used_skill = true
	select_area.show()
	print("initiate")
	
	set_process(true)

func get_direction():
	return (mouse_position - player.global_position).normalized()

func _handle_anim():
	player.get_node("anim").play("idle_" + player.get_node("DirectionTracker").get_action_direction(mouse_position))
