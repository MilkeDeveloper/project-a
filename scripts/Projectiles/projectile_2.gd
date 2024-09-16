extends Area2D

# Propriedades configuráveis
var initial_direction = Vector2.ZERO  # Direção inicial do projétil (espalhada)
var target_direction = Vector2.ZERO  # Direção alvo (direção do mouse)
var speed = 400  # Velocidade do projétil
var curve_speed = 3.0  # Velocidade de curvatura

# Variável para armazenar a direção atual do projétil
var current_direction = Vector2.ZERO

func _ready():
	# Define a direção atual para a direção inicial
	current_direction = initial_direction
	rotation = current_direction.angle()

func _process(delta):
	# Gradualmente ajusta a direção atual para a direção alvo usando interpolação linear
	current_direction = current_direction.lerp(target_direction, curve_speed)
	current_direction = current_direction.normalized()
	
	# Move o projétil na direção atual
	position += current_direction * speed * delta
	
	# Atualiza a rotação para apontar na direção de movimento
	rotation = current_direction.angle()

func _on_Projectile_body_entered(body):
	# Lógica de colisão aqui
	queue_free()
