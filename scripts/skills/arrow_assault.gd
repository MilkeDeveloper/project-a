extends SkillBase

class_name  ArrowAssault

var direction: Vector2
var logic = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	direction = global_position.direction_to(get_global_mouse_position()).normalized()
	var projectile = Projectile.instantiate()
	
	projectile.projectile_data.texture = projectile_config.texture
	projectile.projectile_data.Projectile_logic = projectile_config.Projectile_logic
	projectile.var_direction =  direction
	projectile.var_speed = projectile_config.projectile_speed
	projectile.var_max_distance = projectile_config.max_distance
	
	add_child(projectile)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if cast_skill:
		pass
		

func use_skill(_player, skill_damage, _cooldown, anim_component, target):
	player = _player
	damage = skill_damage
	cooldown = _cooldown
	cast_skill = true
	
	set_process(true)
	
	
	
func cancel_skill():
	pass

func _input(event: InputEvent) -> void:
	pass
