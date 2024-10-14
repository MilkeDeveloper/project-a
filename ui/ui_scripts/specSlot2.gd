extends HBoxContainer


@export var secondary_spec: Array[SkillGrimoireData]
@export var InvSkill: GridContainer
@export var spec_slot: TextureButton
@export var preview_texture: TextureRect 

var is_on_slot: bool = false
var released: bool = false

var _item: SkillGrimoireData
var _index: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_spec_slots()
	connect_signals()

func connect_signals():
	SkillMenuGlobals.on_grimoire_clicked.connect(_on_receive_item2)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_spec_slots():
	if secondary_spec[0] != null:
		spec_slot.texture_normal = secondary_spec[0].grimoire_icon

func _on_grimoire_icon_mouse_entered() -> void:
	is_on_slot = true
	SkillMenuGlobals.on_spec_slot = true
	print("on specialization slot")

func _input(event: InputEvent) -> void:
	if event.is_action_released("mouse_left"):
		if is_on_slot:
			released = true
			equip_grimoire()
		else:
			_item = null
		
func _on_receive_item2(item: SkillGrimoireData, index: int):
	_item = item
	_index = index
	if released:
		item = null
	
	
func equip_grimoire():
	print("sinal recebido")
	if secondary_spec[0] == null and _item != null:
		secondary_spec[0] = _item
		is_on_slot = false
		_item = null
		preview_texture.hide()
		InvSkill.GrimoireInv[_index] = null
		print("spec reached")
		InvSkill.get_grimoire_slot_inv()
		update_spec_slots()
		SkillMenuGlobals.clear_dragged_item.emit()
		
	elif secondary_spec[0] != null and _item != null:
		InvSkill.GrimoireInv[_index] = secondary_spec[0]
		secondary_spec[0] = _item
		is_on_slot = false
		_item = null
		preview_texture.hide()
		
		print("spec reached")
		SkillMenuGlobals.clear_dragged_item.emit()
		InvSkill.get_grimoire_slot_inv()
		update_spec_slots()

func _on_grimoire_icon_mouse_exited() -> void:
	print("saindo")
	_item = null
	is_on_slot = false
