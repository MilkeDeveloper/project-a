extends HBoxContainer


@export var preview_texture: TextureRect
@export var skill_manager: SkillManager
@export var player: CharacterBody2D

var skill_hotbar1: Array[GDSkillData]
var ui_hotbar_slots = []
var on_slot: bool = false
var slot_index: int
var skill: GDSkillData
var is_dragging: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_ui_hotbar_slots()
	connect_hover_buttons()
	update_skill_hotbar()
	connect_signals()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_dragging:
		preview_texture.global_position = get_global_mouse_position() - preview_texture.size / 2

# Função para definir os slots da ui hotbar
func set_ui_hotbar_slots():
	for slot in get_children():
		if slot is TextureButton:
			ui_hotbar_slots.append(slot)

# Função para conectar os sinais de drag and drop
func connect_signals():
	SkillMenuGlobals.dragg_from_skill_menu.connect(_set_skill_data_to_drop)

# Função para conectar os sinais dos botões da hotbar
func connect_hover_buttons():
	for i in range(ui_hotbar_slots.size()):
		var slot = ui_hotbar_slots[i]
		var callable = Callable(_mouse_on_slot)
		callable = callable.bind(i)
		slot.connect("mouse_entered", callable)
		
		var pressed = Callable(_on_slot_pressed)
		pressed = pressed.bind(i)
		slot.connect("pressed", pressed)
		
		var exit_callable = Callable(_mouse_out_slot)
		exit_callable = exit_callable.bind(i)
		slot.connect("mouse_exited", exit_callable)

# Função para atualizar a hotbar física
func update_skill_hotbar():
	skill_hotbar1 = skill_manager.hotbar_skills
	get_skills_in_hotbar()

# Função para obter toda a parte gráfica da hotbar
func get_skills_in_hotbar():
	for i in range(ui_hotbar_slots.size()):
		var hotbar_slot = ui_hotbar_slots[i]
		
		# Aqui se foi encontrada uma skill no slot, mostra a o icone da skill
		if skill_hotbar1[i] != null:
			hotbar_slot.texture_normal = skill_hotbar1[i].skill_icon
		else:
			hotbar_slot.texture_normal = load("res://assets/misc/hotbar_slot_remake.png")

# Função para soltar a skill que foi arrastada do menu de skills
func drop_skill_from_skill_menu(dragged_skill: GDSkillData, index: int):
	# Aqui, se há uma skill sendo arrastada, adicione a skill no slot
	if dragged_skill != null:
		skill_hotbar1[index] = dragged_skill
		preview_texture.hide()
		preview_texture.texture = null
		is_dragging = false
		dragged_skill = null
		slot_index = -1
		skill = null
	else:
		preview_texture.hide()
		preview_texture.texture = null
		is_dragging = false
		dragged_skill = null
		slot_index = -1
		skill = null
	# Atualiza a hotbar após a mudança
	update_skill_hotbar()

# Função para lidar com o input de soltar a skill
func _input(event: InputEvent) -> void:
	if event.is_action_released("mouse_left"):
		# Aqui se o mouse estiver sobre um slot válido, chama a função para soltar a skill no slot
		if on_slot:
			drop_skill_from_skill_menu(skill, slot_index)
		else:
			slot_index = -1
			skill = null
			preview_texture.hide()
			preview_texture.texture = null
			is_dragging = false

# Função para verificar se o mouse está sobre um slot
func _mouse_on_slot(index: int):
	print("on slot: " + str(index))
	slot_index = index
	on_slot = true

# Função para verificar quando o mouse sai do slot
func _mouse_out_slot(index: int):
	print("saiu do slot: " + str(index))
	on_slot = false

# Função para verificar se o slot foi pressionado
func _on_slot_pressed(index: int):
	print("hotbar slot pressed: " + str(index))
	# Se há uma skill no slot pressionado, chame a função do skill manager para ativar a skill
	if skill_hotbar1[index] != null:
		skill_manager.activate_skill(skill_hotbar1[index].id, player)
	else:
		print("Não há skill o slot pressionado")

# Função que recebe o sinal com a skill que está sendo arrastada para o slot da hotbar
func _set_skill_data_to_drop(dragged_skill: GDSkillData):
	skill = dragged_skill
	is_dragging = true
	preview_texture.show()
	preview_texture.texture = dragged_skill.skill_icon
	print("dragged skill: " + dragged_skill.skill_name)
