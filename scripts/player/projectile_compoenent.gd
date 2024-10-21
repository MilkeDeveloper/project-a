extends Node2D

@export var Projectile : PackedScene  # Carrega a cena do projétil
@export var SkillColdown: Timer # Timer que controla o cooldown da skill

var shoot_cooldown: float = 1.0  # Tempo entre rajadas de tiros
var num_arrows = 5  # Número de flechas por rajada
var spread_factor: float = 0.1  # Fator de espalhamento; quanto maior, mais rápido os projéteis se afastam uns dos outros
var curve_speed: float = 2.0  # Velocidade com que os projéteis se alinham à direção alvo
var skill_manager : Node # Gerenciador de skills
var cooldown_left: float # Tempo restate de cooldown da skill
var skill_dmg: int
var mouse_position: Vector2
var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
# Função que contem a lógica principal da skill
func use_skill(node, damage, _cooldown, _target = null):
	# Posição do player
	player = node
	var position = node.global_position
	# Obtém a posição do mouse e calcula a direção base
	var mouse_position = node.get_global_mouse_position()
	var base_direction = (mouse_position - position).normalized()

	
	for i in range(num_arrows):
		# Instancia o projétil
		var projectile = Projectile.instantiate()
		projectile.position = position
		projectile.damage = randi_range((damage * 0.8), damage)
		projectile.attacker = node
		
		# Aplica uma ligeira variação à direção base para criar o espalhamento
		var spread_angle = (i - num_arrows / 2) * spread_factor
		var projectile_direction = base_direction.rotated(spread_angle).normalized()

		projectile.direction = projectile_direction  # Direção normalizada
		await get_tree().create_timer(0.1).timeout
		node.get_parent().get_parent().add_child(projectile)
		print("Usou a skill: SpreadShoot" )

func _handle_anim():
	player.get_node("anim").play("idle_" + player.get_node("DirectionTracker").get_action_direction(mouse_position))
