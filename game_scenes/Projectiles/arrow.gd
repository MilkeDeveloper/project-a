extends ProjectileBase

var var_direction = Vector2.ZERO # Inicializa a variável de direção
var my_direction: Vector2
var var_speed: float
var var_max_distance: float
var var_attacker: Node2D
var var_damage: int


func _ready() -> void:
	sprite.texture = projectile_data.texture  # Define a textura do sprite
	# Setar o novo script
	set_script(projectile_data.Projectile_logic)
	var_attacker = get_parent().get_node("Player")
	# Verifica se o novo script tem as variáveis e restaura os valores
	if has_method("get_vars"):  # Verifica se o método existe no novo script
		get_vars(var_direction, var_speed, var_max_distance, var_attacker, var_damage) # Chama o método do novo script
		
	else:
		print("Warning: set_my_direction method does not exist in the new script.")

	call("_ready")  # Chama o _ready() do novo script
	
func get_vars(direction: Vector2, speed: float, max_distance: float, attacker: Node2D, damage: int) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	GLobals.emit_signal("body_entered", body)
	
	
