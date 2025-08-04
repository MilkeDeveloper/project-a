extends ProjectileBase

var speed = 800
var max_distance = 500  # Distância máxima que o projétil percorrerá
var start_position = Vector2.ZERO
var travel_distance = 0
var mouse_position
var damage: int
var attacker: Node2D 
var my_direction: Vector2

func _ready() -> void:
	rotation = my_direction.angle()
#	$shoot_arrow.play(0.86)
	GLobals.connect("body_entered", _on_body_entered)
	set_physics_process(true)
	
func _physics_process(delta):
	movement(delta)
	
func _on_Projectile_body_entered(body):
	# Lógica de colisão aqui
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("entity"):
		GLobals.emit_signal("cam_shake", 5.5, 0.5)
		if body.has_method("take_damage"):
			body.take_damage(damage, attacker, body, "magic_hit")
			print(attacker, body)
			queue_free()

func get_vars(direction: Vector2, _speed: float, _max_distance: float, _attacker: Node2D, _damage: int) -> void:
	my_direction = direction  # Define a direção recebida
	speed = _speed
	max_distance = _max_distance
	attacker = _attacker
	damage = _damage

func movement(delta):
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
	
	
