extends HBoxContainer


@export var secondary_spec: Array[SpecGrimoireData]
@export var InvSkill: GridContainer
@export var spec_slot: TextureButton
@export var preview_texture: TextureRect
@export var spec2_panel: HBoxContainer
@export var spec_alert: Label

var is_on_slot: bool = false
var released: bool = false

var _item: SpecGrimoireData
var _index: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_spec_slots()
	connect_signals()

func connect_signals():
	SkillMenuGlobals.on_grimoire_clicked2.connect(_on_receive_item2)
		
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

		
func _on_receive_item2(item: SpecGrimoireData, index: int):
	equip_grimoire(item, index)

func equip_grimoire(item: SpecGrimoireData, i: int):
	print("sinal recebido")
	if secondary_spec[0] == null and item != null:
		secondary_spec[0] = item
		is_on_slot = false
		item = null
		preview_texture.hide()
		InvSkill.GrimoireInv[i] = null
		print("spec reached")
		InvSkill.get_grimoire_slot_inv()
		update_spec_slots()
		update_spec_info()
		SkillMenuGlobals.clear_dragged_item.emit()
	else:
		print("slot já ocupado")
		InvSkill.GrimoireInv[i] = item
		InvSkill.get_grimoire_slot_inv()
		update_spec_slots()

func update_spec_info():
	spec_alert.hide()
	spec2_panel.show()
	spec2_panel.show_spec_info()

func _on_grimoire_icon_mouse_exited() -> void:
	print("saindo")
	is_on_slot = false


func _on_grimoire_icon_pressed() -> void:
	print("secondary spec selected")
	ItemGlobals.primary_skill_active = false
	ItemGlobals.secondary_skill_active = true
	SkillMenuGlobals.current_primary_spec_slot_selected = false
	SkillMenuGlobals.current_secondary_spec_slot_selected = true
	
