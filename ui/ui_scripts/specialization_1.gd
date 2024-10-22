extends HBoxContainer

@export var spec_slot1: HBoxContainer
@export var spec_icon: TextureRect
@export var spec_level: Label
@export var progression_text: Label
@export var progression_item: ItemData
@export var PlayerInv: Inventory
@export var progression_bar: TextureProgressBar
@export var spec_panel: Panel
@export var weapon1_grimoire_slots: Panel
@export var spec_button: TextureButton
@export var panel_title: Label
@export var spec_lvup_btn: TextureButton

var spec : SpecData
var shards: ItemData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_spec_info()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	show_spec_info()

func show_spec_info():
	if spec_slot1.primary_spec[0] != null:
		get_progression_item_necessary()
		
		spec = spec_slot1.primary_spec[0].spec
		spec_icon.texture = spec.spec_icon
		spec_level.text = "Lv. " + str(spec.spec_level)
		progression_text.text = str(shards.stacks) + "/" + str(calculate_necessary_items_for_next_level(spec.spec_level)) if shards != null else str(0) + "/" + str(calculate_necessary_items_for_next_level(spec.spec_level))
		progression_bar.max_value = calculate_necessary_items_for_next_level(spec.spec_level)
		progression_bar.value = shards.stacks if shards != null else 0
		
		if shards != null:
			if shards.stacks < calculate_necessary_items_for_next_level(spec.spec_level):
				spec_lvup_btn.hide()
			elif shards.stacks >= calculate_necessary_items_for_next_level(spec.spec_level):
				spec_lvup_btn.show()
		else:
			spec_lvup_btn.hide()

func get_progression_item_necessary():
	for slot in PlayerInv.material_slots:
		if slot != null:
			var item = slot
			if item.item_id == progression_item.item_id:
				shards = item

func calculate_necessary_items_for_next_level(level: int, initial_shards: int = 25, growth_factor: float = 1.3) -> float:
	var shards_needed = initial_shards * pow(growth_factor, level - 1)
	return round(shards_needed)


func _on_spec_button_pressed() -> void:
	if spec_slot1.primary_spec[0] != null:
		ItemGlobals.secondary_skill_active = false
		ItemGlobals.primary_skill_active = false
		SkillMenuGlobals.curent_primary_skill_selected = false
		SkillMenuGlobals.curent_secondary_skill_selected = false
		weapon1_grimoire_slots.clear_grimoire_slots()
		spec_button.hide()
		spec_panel.show()
		panel_title.text = "Specialization"
		


func _on_texture_button_pressed() -> void:
	if spec.spec_level < spec.spec_max_level:
		var shards_to_remove = calculate_necessary_items_for_next_level(spec.spec_level)
		shards.stacks = shards.stacks - shards_to_remove
		spec.spec_level += 1
