extends SkillBase

class_name SpreadShoot

@export var charge_bar: TextureProgressBar
@export var charge_label: Label
@export var spread_factor: float = 0.1  # Fator de espalhamento; quanto maior, mais rápido os projéteis se afastam uns dos outros
@export var num_arrows = 5 # Número de flechas por rajada

var shoot_cooldown: float = 1.0  # Tempo entre rajadas de tiros
var curve_speed: float = 2.0  # Velocidade com que os projéteis se alinham à direção alvo
var skill_manager : Node # Gerenciador de skills
var cooldown_left: float # Tempo restate de cooldown da skill
var skill_dmg: int
var charge_time: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#charge bar
	charge_bar.max_value = cast_time
	charge_bar.value = charge_time
	charge_label.text = ""
	
	set_process(false)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	skill_charge(delta)
	
# Função que contem a lógica principal da skill
func use_skill(node, skill_damage, _cooldown, _cast_time, _target = null):
	# Posição do player
	player = node
	damage = skill_damage
	cooldown = _cooldown
	cast_time = _cast_time

	start_charge()
	set_process(true)

func start_charge():
	is_charging = true
	charge_time = 0.0 # Reinicia o tempo de carregamento da skill
	charge_bar.max_value = cast_time
	charge_bar.value = 0 # Reinicia a charge bar
	print("Charging...")

func start_spread_shoot() -> void:
	var position = player.global_position
	# Obtém a posição do mouse e calcula a direção base
	var mouse_position = get_global_mouse_position()
	var base_direction = (mouse_position - position).normalized()

	
	for i in range(num_arrows):
		# Instancia o projétil
		# Aplica uma ligeira variação à direção base para criar o espalhamento
		var spread_angle = (i - num_arrows / 2) * spread_factor
		var projectile_direction = base_direction.rotated(spread_angle).normalized()
		
		var projectile = Projectile.instantiate()
		
		projectile.position = player.global_position
		projectile.projectile_data.texture = projectile_config.texture
		projectile.projectile_data.Projectile_logic = projectile_config.Projectile_logic
		projectile.var_direction =  projectile_direction
		projectile.var_speed = projectile_config.projectile_speed
		projectile.var_max_distance = projectile_config.max_distance
		projectile.var_attacker = player
		projectile.var_damage = randi_range(damage * 0.8, damage)
		

		#await get_tree().create_timer(0.1).timeout
		get_parent().get_parent().add_child(projectile)
		print("Usou a skill: SpreadShoot" )
	
	_handle_anim()

func skill_charge(delta: float):
	# Se está carregando a habilidade incrementa o charge time
	if is_charging:
		charge_time += delta
		# Limita o charge time com o tempo de duração máximo da skill
		if charge_time >= cast_time:
			charge_time = cast_time
			charge_label.visible_characters = 10
			charge_label.text = str("Charged")
			# lança a skill
		
		else:
			
			# Atualiza o charge bar
			charge_bar.value = charge_time
			charge_label.text = str(charge_time)
			print("skill charging")

# Função para cancelar o carregamento da skill
func cancel_skill():
	if is_charging:
		# Aqui se o cast da skill foi carregado até o final, a skill é ativada, caso contrário, o carregamento é apenas cancelado.
		if charge_time >= cast_time:
			start_spread_shoot()
			is_charging = false
		else:
			is_charging = false
	
	charge_bar.value = 0 # Reseta a charge bar após o encerramento da skill
	queue_free()

# Aqui iniciamos a animação do personagem durante a ativação da skill
func _handle_anim():
	player.get_node("anim").play("idle_" + player.get_node("DirectionTracker").get_action_direction(get_global_mouse_position()))
	
