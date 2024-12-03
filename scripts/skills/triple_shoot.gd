extends Node2D

@export var Projectile: PackedScene
@export var ProjectileConfig: ProjectileData
@onready var select_area: Sprite2D = $Sprite2D

@export var arrows_sequence = 1
@export var time_between_arrows = 0.4

var anim_direction
var skill_manager
var skill_cooldown

var player
var used_skill
var mouse_position
var is_on_cooldown
var skill_dmg 
var shoot_count: int



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
	
		
	if used_skill and GLobals.target:
		#GLobals.emit_signal("on_click")
		used_skill = false
		#select_area.hide()
		mouse_position = get_global_mouse_position()
		for arrow in arrows_sequence:
			var projectile = Projectile.instantiate()
			if shoot_count == 0:
				projectile.position = $Marker2D3/Marker2D.global_position
				shoot_count += 1
			else:
				projectile.position = $Marker2D3/Marker2D2.global_position
				shoot_count = 0

			projectile.projectile_data.texture = ProjectileConfig.texture
			projectile.projectile_data.Projectile_logic = ProjectileConfig.Projectile_logic
			projectile.var_damage = randi_range((skill_dmg * 0.5), skill_dmg)
			projectile.var_attacker = player
			projectile.var_max_distance = ProjectileConfig.max_distance
			projectile.var_speed = ProjectileConfig.projectile_speed
			
			#projectile.target_position = get_global_mouse_position()
			if GLobals.target != null:
				var direction = (GLobals.target.global_position - get_parent().global_position).normalized()
				projectile.var_direction = direction
				
				$Marker2D3.rotation = direction.angle()
				
				_handle_anim()
				get_parent().get_parent().add_child(projectile)
				#projectile.get_node("animation")._on_animate_fireball()
				await get_tree().create_timer(time_between_arrows).timeout
			
		set_process(false)
	
func use_skill(node, damage, _cooldown, anim_component, _target = null):
	skill_dmg = damage
	skill_cooldown = _cooldown
	player = node
	used_skill = true
	#select_area.show()
	print("initiate")
	
	set_process(true)

func get_direction():
	return (mouse_position - player.global_position).normalized()

func _handle_anim():
	player.get_node("anim").play("idle_" + player.get_node("DirectionTracker").get_action_direction(mouse_position))
