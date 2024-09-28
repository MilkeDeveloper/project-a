extends ProjectileBase

var speed = 800
var max_distance = 500  # Distância máxima que o projétil percorrerá
var start_position = Vector2.ZERO
var travel_distance = 0
var mouse_position
var damage: int
var attacker

func _ready() -> void:
	#rotation = direction.angle()
	#$shoot_arrow.play(0.86)
	print('im ready')
	pass
	
func _physics_process(delta):
	print("movendoooo")
	if travel_distance < max_distance:
		var move_step = speed * delta
		travel_distance += move_step
		global_position += Vector2.RIGHT * move_step
	else:
		queue_free()  # Remove o projétil quando atingir a distância máxima
	
	#if global_position.distance_to(mouse_position) < 10:
		#queue_free()
	# Rotaciona a flecha para apontar na direção do movimento
	rotation = projectile_data.direction.angle()
	
func _on_Projectile_body_entered(body):
	# Lógica de colisão aqui
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("entity"):
		if body.has_method("take_damage"):
			body.take_damage(damage, attacker, body, "magic_hit")
			queue_free()
		
