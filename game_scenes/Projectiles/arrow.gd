extends ProjectileBase

var var_direction = Vector2.ZERO # Inicializa a variável de direção
var my_direction: Vector2
var var_speed: float
var var_max_distance: float

func _ready() -> void:
	sprite.texture = projectile_data.texture  # Define a textura do sprite
	# Define a direção para o mouse
	print("Direction before setting script:", var_direction)
	# Setar o novo script
	set_script(projectile_data.Projectile_logic)

	# Verifica se o novo script tem as variáveis e restaura os valores
	if has_method("get_vars"):  # Verifica se o método existe no novo script
		get_vars(var_direction, var_speed, var_max_distance)  # Chama o método do novo script
		
	else:
		print("Warning: set_my_direction method does not exist in the new script.")

	call("_ready")  # Chama o _ready() do novo script
	
func get_vars(direction: Vector2, speed: float, max_distance: float) -> void:
	pass  # Define a direção recebida

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
