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

func set_ui_hotbar_slots():
	for slot in get_children():
		if slot is TextureButton:
			ui_hotbar_slots.append(slot)

func connect_signals():
	SkillMenuGlobals.dragg_from_skill_menu.connect(_set_skill_data_to_drop)

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

func update_skill_hotbar():
	skill_hotbar1 = skill_manager.hotbar_skills
	get_skills_in_hotbar()

func get_skills_in_hotbar():
	for i in range(ui_hotbar_slots.size()):
		var hotbar_slot = ui_hotbar_slots[i]
		
		if skill_hotbar1[i] != null:
			hotbar_slot.texture_normal = skill_hotbar1[i].skill_icon
		else:
			hotbar_slot.texture_normal = load("res://assets/misc/hotbar_slot_remake.png")

func drop_skill_from_skill_menu(dragged_skill: GDSkillData, index: int):
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
	update_skill_hotbar()

func _input(event: InputEvent) -> void:
	if event.is_action_released("mouse_left"):
		if on_slot:
			drop_skill_from_skill_menu(skill, slot_index)
		else:
			slot_index = -1
			skill = null
			preview_texture.hide()
			preview_texture.texture = null
			is_dragging = false

func _mouse_on_slot(index: int):
	print("on slot: " + str(index))
	slot_index = index
	on_slot = true
	
func _mouse_out_slot(index: int):
	print("saiu do slot: " + str(index))
	on_slot = false

func _on_slot_pressed(index: int):
	print("hotbar slot pressed: " + str(index))
	if skill_hotbar1[index] != null:
		skill_manager.activate_skill(skill_hotbar1[index].id, player)
	else:
		print("Não há skill o slot pressionado")
		
func _set_skill_data_to_drop(dragged_skill: GDSkillData):
	skill = dragged_skill
	is_dragging = true
	preview_texture.show()
	preview_texture.texture = dragged_skill.skill_icon
	print("dragged skill: " + dragged_skill.skill_name)
