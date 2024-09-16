extends Area2D

var speed = 1400
var max_distance = 500  # Distância máxima que o projétil percorrerá
var direction = Vector2.ZERO
var start_position = Vector2.ZERO
var travel_distance = 0

	
func _physics_process(delta):
	if travel_distance < max_distance:
		var move_step = speed * delta
		travel_distance += move_step
		global_position += direction * move_step
	else:
		queue_free()  # Remove o projétil quando atingir a distância máxima
		
	# Rotaciona a flecha para apontar na direção do movimento
	rotation = direction.angle()
	
func _on_Projectile_body_entered(body):
	# Lógica de colisão aqui
	queue_free()
