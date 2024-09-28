extends SkillBase

class_name  ArrowAssault

@export var skill_timer: float
@export var time_between_arrows: float

var direction: Vector2
var available_angles = [] # Lista para armazenar os ângulos disponíveis
var player_position: Vector2
var original_speed: float
var original_player: Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Crie uma lista de ângulos únicos (em radianos), aqui 360 ângulos, mas você pode ajustar
	for i in range(0, 360, 15):
		available_angles.append(deg_to_rad(i))
	
	# Embaralhe a lista para garantir que a sequência seja aleatória
	available_angles.shuffle()
	
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if cast_skill:
		player_position = original_player.global_position

func start_timers():
	$skillTimer.start(skill_timer)
	$time_between_arrows.start(time_between_arrows)

func use_skill(_player, skill_damage, _cooldown, anim_component, target):
	original_player = _player
	damage = skill_damage
	cooldown = _cooldown
	cast_skill = true
	original_speed = original_player.SPEED
	original_player.SPEED = original_speed / 3
	GLobals.spinning = true
	start_timers()
	set_process(true)

func shoot_random_direction():
	randomize()
	# Verifique se ainda há ângulos disponíveis
	if available_angles.size() == 0:
		# Se a lista de ângulos estiver vazia, recrie e embaralhe os ângulos
		for i in range(0, 360, 15):
			available_angles.append(deg_to_rad(i))
		available_angles.shuffle()
	
	# Pegue o próximo ângulo disponível
	var random_angle = available_angles.pop_back()  # Pega e remove o último ângulo da lista
	
	# Converta o ângulo em um vetor de direção
	direction = Vector2(cos(random_angle), sin(random_angle)).normalized()
	
	var projectile = Projectile.instantiate()
	
	projectile.position = original_player.global_position
	projectile.projectile_data.texture = projectile_config.texture
	projectile.projectile_data.Projectile_logic = projectile_config.Projectile_logic
	projectile.var_direction =  direction
	projectile.var_speed = projectile_config.projectile_speed
	projectile.var_max_distance = projectile_config.max_distance
	projectile.var_attacker = original_player
	projectile.var_damage = randi_range(damage * 0.8, damage)
	
	get_parent().get_parent().add_child(projectile)
	_handle_anim()
	
func cancel_skill():
	pass

func _input(event: InputEvent) -> void:
	pass

func _handle_anim():
	get_parent().get_node("anim").play("crossbow_spin")

func _on_skill_timer_timeout() -> void:
	cast_skill = false
	original_player.SPEED = original_speed
	GLobals.spinning = false
	$time_between_arrows.stop()
	queue_free()


func _on_time_between_arrows_timeout() -> void:
	if cast_skill:
		shoot_random_direction()
