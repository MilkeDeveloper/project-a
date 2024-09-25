extends Area2D

@export var max_enemies: int = 6
@export var pull_radius: int = 150  # Raio menor para onde os inimigos são puxados
@export var slow_percentage: float  = 0.5  # Redução de velocidade em 50%
@export var damage_per_tick: int = 10  # Dano por tick (0.3s)
@export var explosion_damage: int = 100  # Dano da explosão final
@export var totem_duration: float = 10.0  # Duração do totem
@export var tick_interval: float = 0.3  # Intervalo de 0.3 segundos para o dano contínuo
@export var corrent_scene: PackedScene


var affected_enemies = []
var current_corresponding_lines: Array = []
var attacker: CharacterBody2D
var i_speed: float = 150
var current_chain


func _ready():
	# Inicia o temporizador para a duração do totem
	$TotemDurationTimer.start(totem_duration)
	$DamageTimer.start(tick_interval)

func _process(delta: float) -> void:
	_supress_enemies()

func _on_TotemDurationTimer_timeout():
	# Causa a explosão final ao fim da duração
	create_explosion()
	$colision.disabled = true
	await $anim.animation_finished
	queue_free()  # Remove o totem após a explosão

func _on_DamageTimer_timeout():
	# Aplica dano a cada 0.3 segundos nos inimigos presos
	for enemy in affected_enemies:
		enemy.take_damage(damage_per_tick, attacker, enemy, "magic_hit")
		
func create_explosion():
	# Explosão em uma área de 300x300
	var explosion_area = $ExplosionArea.get_overlapping_bodies()
	for enemy in explosion_area:
		if enemy.is_in_group("entity"):
			enemy.take_damage(explosion_damage, attacker, enemy, "magic_hit")
	$anim.play("dark_explosion")

func _on_Area2D_body_entered(body):
	if body.is_in_group("entity") and affected_enemies.size() < max_enemies:
		affected_enemies.append(body)
		create_connection(body)
		_supress_enemies()
		#body.apply_slow(slow_percentage)  # Aplica a redução de velocidade

func _on_Area2D_body_exited(body):
	if body in affected_enemies:
		affected_enemies.erase(body)
		remove_connection(body)
		#body.remove_slow()  # Remove a redução de velocidade ao sair

func _supress_enemies():
	# Se o inimigo tentar sair mais de 50 pixels da área menor, ele será puxado de volta
	for enemy in affected_enemies:
		if enemy.global_position.distance_to(self.global_position) > pull_radius + 25:
			var target_position = (enemy.global_position - global_position).normalized()
			enemy.velocity -= target_position * i_speed
			enemy.move_and_slide()
			
			enemy.get_node("navigation").set_destination(target_position)

# Instancia a cena da corrente e conecta ao inimigo
func create_connection(body: Node2D):
	var corrente_scene = corrent_scene
	var corrente_instance = corrente_scene.instantiate()
	current_chain = corrente_instance
	add_child(corrente_instance)  # Adicione a corrente como filha do totem
	corrente_instance.set_connections(self, body)
	current_corresponding_lines.append(corrente_instance)

# Remove a instancia da corrente quando o inimigo sai da area ou morre
func remove_connection(body):
	for i in range(current_corresponding_lines.size()):
		var corrente = current_corresponding_lines[i]
		if corrente != null and corrente.get_connected_enemy() == body:
			corrente.queue_free()  # Remove a corrente da cena
			current_corresponding_lines.erase(i)  # Remove da lista de correntes
			break

func emit_cam_shake():
	GLobals.emit_signal("cam_shake", 5.4, 0.6)
