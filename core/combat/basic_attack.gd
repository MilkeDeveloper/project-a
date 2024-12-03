extends Node2D

@export var Projectile : PackedScene
@export var ProjectileConfig: ProjectileData
@export var anim_direction : Node2D
@export var basic_dmg: int
@export var attack_speed: float
@export var attack_range: float
# Called when the node enters the scene tree for the first time.
var timer = Timer.new()
var can_attack = true
var _target
var is_attacking: bool = false

func _ready() -> void:
	add_child(timer)
	timer.wait_time = 50 / attack_speed
	timer.one_shot = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_parent().jumping:
		return
	
	if not can_attack and timer.time_left <= 0:
		on_attack_timer_timout()
		is_attacking = true
	
	

func ranged_basic_attack(target = null):
	_target = target
	
	if not GLobals.target or get_parent().global_position.distance_to(GLobals.target.global_position) > attack_range:
		get_parent().SPEED = 650
		is_attacking = false
		GLobals.target = null
		return
	
	print(is_attacking)
	if can_attack and GLobals.target and get_parent().global_position.distance_to(GLobals.target.global_position) < attack_range:
		var projectile = Projectile.instantiate()
		projectile.position = get_parent().global_position
		projectile.projectile_data.texture = ProjectileConfig.texture
		projectile.projectile_data.Projectile_logic = ProjectileConfig.Projectile_logic
		projectile.var_damage = randi_range((basic_dmg * 0.5), basic_dmg)
		projectile.var_attacker = get_parent()
		projectile.var_max_distance = ProjectileConfig.max_distance
		projectile.var_speed = ProjectileConfig.projectile_speed
		
		#projectile.target_position = get_global_mouse_position()
		var direction = (GLobals.target.global_position - get_parent().global_position).normalized()
		projectile.var_direction = direction
		
		_handle_anim()
		
		get_parent().SPEED = 650
		get_parent().get_parent().add_child(projectile)
		#projectile.launch_fireball()
		
		timer.start()
		can_attack = false
		get_parent().is_in_combat = true

	else :
		get_parent().SPEED = 650

func _handle_anim():
	get_parent().get_node("anim").play("run_" + get_parent().get_node("DirectionTracker").get_action_direction(_target.global_position))
		
func on_attack_timer_timout():
	can_attack = true
	#is_attacking = true
	ranged_basic_attack(_target)
