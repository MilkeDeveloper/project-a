extends Node2D

@export var Projectile : PackedScene  # Carrega a cena do projétil
@export var SkillColdown: Timer # Timer que controla o cooldown da skill

var shoot_cooldown: float = 1.0  # Tempo entre rajadas de tiros
var num_arrows = 5  # Número de flechas por rajada
var spread_factor: float = 0.3  # Fator de espalhamento; quanto maior, mais rápido os projéteis se afastam uns dos outros
var curve_speed: float = 2.0  # Velocidade com que os projéteis se alinham à direção alvo
var skill_manager : Node # Gerenciador de skills
var cooldown_left: float # Tempo restate de cooldown da skill

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	if is_inside_tree():
		skill_manager = get_parent().find_child("SkillManager")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
# Função que contem a lógica principal da skill
func use_skill(node, _cooldown, anim_component, _target = null):
	shoot_cooldown = _cooldown
		
	if GLobals.target == null or node.global_position.distance_to(GLobals.target.global_position) > 300:
		print(GLobals.target)
		print("O alvo está fora do alcance da skill")
		return
	# Posição do player
	var position = node.global_position
	if GLobals.target != null and node.is_in_group("player") and node.global_position.distance_to(GLobals.target.global_position) < 300:
			anim_component.update_blend_position(GLobals.target.global_position)
	# Obtém a posição do mouse e calcula a direção base
	var mouse_position = node.get_global_mouse_position()
	var base_direction = (_target.global_position - position).normalized()
	
	for i in range(num_arrows):
		# Instancia o projétil
		var projectile = Projectile.instantiate()
		projectile.position = position
		
		# Aplica uma ligeira variação à direção base para criar o espalhamento
		var spread_angle = (i - num_arrows / 2) * spread_factor
		var projectile_direction = base_direction.rotated(spread_angle).normalized()

		projectile.direction = projectile_direction  # Direção normalizada
		
		node.get_parent().get_parent().add_child(projectile)
		print("Usou a skill: SpreadShoot" )
	skill_manager.can_skill = false
	SkillColdown.start(shoot_cooldown)

func skill_time_left():
	return cooldown_left
	
func _on_skill_coldown_timeout() -> void:
	print("skill pronta para o uso novamente")
	skill_manager.can_skill = true
