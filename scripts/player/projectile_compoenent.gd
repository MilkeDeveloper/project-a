extends Node2D

@export var Projectile : PackedScene  # Carrega a cena do projétil
@export var node: Node2D
@export var anim_component: Node2D
var shoot_cooldown = 1.0  # Tempo entre rajadas de tiros
var can_shoot = true
var num_arrows = 5  # Número de flechas por rajada
var spread_factor: float = 0.3  # Fator de espalhamento; quanto maior, mais rápido os projéteis se afastam uns dos outros
var curve_speed: float = 2.0  # Velocidade com que os projéteis se alinham à direção alvo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func shoot_spreading_projectiles(_target):
	if GLobals.target == null or node.global_position.distance_to(GLobals.target.global_position) > 300:
		print(GLobals.target)
		return
	# Posição do player
	var position = global_position
	if GLobals.target != null and node.is_in_group("player") and node.global_position.distance_to(GLobals.target.global_position) < 300:
			anim_component.update_blend_position(GLobals.target.global_position)
	
	
	# Obtém a posição do mouse e calcula a direção base
	var mouse_position = get_global_mouse_position()
	var base_direction = (_target.global_position - position).normalized()
	
	for i in range(num_arrows):
		# Instancia o projétil
		var projectile = Projectile.instantiate()
		projectile.position = position
		
		# Aplica uma ligeira variação à direção base para criar o espalhamento
		var spread_angle = (i - num_arrows / 2) * spread_factor
		var projectile_direction = base_direction.rotated(spread_angle).normalized()

		projectile.direction = projectile_direction  # Direção normalizada
		
		get_parent().get_parent().add_child(projectile)

	can_shoot = false
	await get_tree().create_timer(shoot_cooldown).timeout
	can_shoot = true

func multi_shoot():
   # Posição do player
	var position = global_position
	
	# Obtém a posição do mouse e calcula a direção base
	var mouse_position = get_global_mouse_position()
	var base_direction = (mouse_position - position).normalized()
	
	for i in range(num_arrows):
		# Instancia o projétil
		var projectile = Projectile.instantiate()
		projectile.position = position
		
		# Aplica uma variação inicial na direção para o espalhamento
		var spread_angle = (i - num_arrows / 2) * spread_factor
		var initial_direction = base_direction.rotated(spread_angle).normalized()
		
		# Define a direção inicial, direção alvo e velocidade de curvatura
		projectile.initial_direction = initial_direction
		projectile.target_direction = base_direction
		projectile.curve_speed = curve_speed

		get_parent().get_parent().add_child(projectile)

	can_shoot = false
	await get_tree().create_timer(shoot_cooldown).timeout
	can_shoot = true
