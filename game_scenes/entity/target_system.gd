extends Area2D

@export var node: Node2D
@export var target_sprite: Sprite2D
@onready var hud_hp: CanvasLayer = $"../hud_entity/HUD_HP"

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
	
func _clear_target():
	target_sprite.hide()
	hud_hp.hide()
	node.hud_entity.hide()
	#GLobals.target = null
	if array_target != null and not array_target.mouse_over:
		GLobals.targets.clear()
		array_target = null
		GLobals.target = null
		print("limpei")
		
func _on_target_area_mouse_entered() -> void:
	print(GLobals.targets)
	print(array_target)
	if get_parent() == array_target:
		array_target.hud_entity.show()
		node.mouse_over = true
	else:
		node.hud_entity.show()
		node.mouse_over = true
		
	node.mouse_over = true
	print(node.targeted)
	
func _on_target_area_mouse_exited() -> void:
	if get_parent() == array_target:
		if node.targeted:
			array_target.hud_entity.hide()
			node.mouse_over = false
	else:
		node.hud_entity.hide()
		node.mouse_over = false
		
	node.mouse_over = false
