extends ProjectileBase

var speed = 800
var max_distance = 500  # Distância máxima que o projétil percorrerá
var start_position = Vector2.ZERO
var travel_distance = 0
var mouse_position
var damage: int
var attacker 
var my_direction: Vector2

func _ready() -> void:
	print("direction :" + str(my_direction))
	print(speed)
	print(max_distance)
	rotation = my_direction.angle()
#	$shoot_arrow.play(0.86)
	set_physics_process(true)
	
func _physics_process(delta):
	movement(delta)
	
func _on_Projectile_body_entered(body):
	# Lógica de colisão aqui
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("entity"):
		if body.has_method("take_damage"):
			body.take_damage(damage, attacker, body, "magic_hit")
			queue_free()

func get_vars(direction: Vector2, var_speed: float, var_max_distance: float) -> void:
	my_direction = direction  # Define a direção recebida
	speed = var_speed
	max_distance = var_max_distance

func movement(delta):
	print("lul")
	if travel_distance < max_distance:
		var move_step = speed * delta
		travel_distance += move_step
		global_position += my_direction * move_step
	else:
		queue_free()  # Remove o projétil quando atingir a distância máxima
	
	#if global_position.distance_to(mouse_position) < 10:
		#queue_free()
	# Rotaciona a flecha para apontar na direção do movimento
	rotation = my_direction.angle()
	
	
