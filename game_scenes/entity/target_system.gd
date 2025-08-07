extends Area2D

class_name target_area

@export var node: Node2D
@export var target_sprite: Sprite2D
@onready var hud_hp: CanvasLayer = $"../sprite/hud_entity/HUD_HP"

# Called when the node enters the scene tree for the first time.
var my_target = null
var array_target = null

func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GLobals.targets.size() > 0:
		array_target = GLobals.targets[0]
	
	if node.mouse_over and Input.is_action_just_pressed("mouse_left"):
		_set_target()

	elif not node.mouse_over and Input.is_action_just_pressed("mouse_left"):
		_clear_target()

# Mostra a hud do imigo clicado
func _set_target():
	my_target = node
	GLobals.targets.clear()
	GLobals.targets.append(my_target)
	node.hud_entity.show()
	target_sprite.show()
	await get_tree().create_timer(0.1).timeout
	if array_target != null:
		array_target.hud_entity.find_child("HUD_HP").show()
		GLobals.target = array_target

# Mostra a hud do alvo atual
func set_hud_target():
	# Se o alvo não for nulo, itera sobre os inimigos no grupo para saber qual é o algo atual
	# Limpa a hud dos inimigos restantes garantindo que apenas a hud do alvo atual seja mostrada
	if GLobals.target != null: 
		for enemy in get_tree().get_nodes_in_group("entity"):
			# Se o inimigo no grupo não for o alvo atual, chama a função para limpar os inimigos
			if  enemy != GLobals.target and not enemy.has_node("dummy"):
				_clear_targets(enemy)
		await get_tree().create_timer(0.1).timeout
		if GLobals.target != null: # Se o alvo não for nulo, mostre a hud dele
			GLobals.target.hud_entity.find_child("HUD_HP").show()
			GLobals.target.get_node("target_area").target_sprite.show()

# Limpa a hud dos inimigos que não são o alvo atual
func _clear_targets(target_to_clear):
	if target_to_clear.hud_entity != null:
		target_to_clear.hud_entity.find_child("HUD_HP").hide()
		target_to_clear.get_node("target_area").target_sprite.hide()

# Limpa a hud dos inimigos
func _clear_target():
	GLobals.target = null
	target_sprite.hide()
	hud_hp.hide()
	node.hud_entity.hide()
	#GLobals.target = null
	if array_target != null and not array_target.mouse_over:
		GLobals.targets.clear()
		array_target = null
		
		
		
func _on_target_area_mouse_entered() -> void:
	print(GLobals.targets)
	
	if get_parent() == array_target:
		array_target.hud_entity.show()
		node.mouse_over = true
	else:
		node.hud_entity.show()
		node.mouse_over = true
		
	node.mouse_over = true
	
	
func _on_target_area_mouse_exited() -> void:
	if get_parent() == array_target:
		if node.targeted:
			array_target.hud_entity.hide()
			node.mouse_over = false
	else:
		node.hud_entity.hide()
		node.mouse_over = false
		
	node.mouse_over = false
