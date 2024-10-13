extends Panel


@export var WeaponSkillTrees: SkillWeaponClass
@export var GrimoireSlots: Array[SkillGrimoireData]
@export var inv_panel: GridContainer
@export var skill_info_panel: Panel
@export var passive_container: VBoxContainer
@export var title_container: Panel
@export var dragging_preview: TextureRect
@export var skill_passive_scene: PackedScene
@export var weapon_type: String


var button_index 
var button_lvup_index 
var grimoire_slots = []
var skill_tree 
var InvSlot 
var dragging_item = null
var is_dragging = false
var grimoireInvSlotIndex_from_dragg = null
var slotReleaseIndex = null
var gSlotReleasedIndex = null

func _ready() -> void:
	get_primary_weapon_skills_ui_slot()
	update_skill_tree_panel()
	get_callable_buttons()
	connect_event_inv_slots()
	connect_event_grimoire_slots()
	connect_event_inv_button()
	

func _process(delta: float) -> void:
	if is_dragging:
		dragging_preview.global_position = get_global_mouse_position() - dragging_preview.size / 2

func update_skill_tree_panel():
	skill_tree = WeaponSkillTrees.Staff
	load_weapon_skill_tree(WeaponSkillTrees.Staff)


func get_primary_weapon_skills_ui_slot():
	button_index = []
	button_lvup_index = []
	for i in range(get_child_count()):
		if get_child(i) is TextureButton:
			# se o filho for um Texture Button, adicionamos ao array de btões
			var skill_button = get_child(i)
			button_index.append(skill_button)
			if skill_button.get_node("texture").get_child(1) is TextureButton:
				var button_lvup = get_child(i).get_node("texture").get_child(1)
				button_lvup_index.append(button_lvup)


func load_weapon_skill_tree(skill_tree: Array[GDSkillData]):
	for i in range(button_index.size()):
		if skill_tree[i] != null:
			button_index[i].texture_normal = skill_tree[i].skill_icon
			button_index[i].get_child(0).show()
			var skilLv_text = button_index[i].get_child(0).get_node("Label")
			skilLv_text.text = str(skill_tree[i].skill_level) + "/" + str(skill_tree[i].skill_max_level)

func get_callable_buttons():
	for _index in range(button_index.size()):
		var skill_button = button_index[_index]
		# Essa variável é responsável pela conexão
		var callable = Callable(_on_skill_button_pressed)
		callable = callable.bind(_index)
		skill_button.connect("pressed", callable)
	
	for b_index in range(button_lvup_index.size()):
		var buttonLvup = button_lvup_index[b_index]
		var buttonCallable = Callable(_on_levelup_button_pressed)
		buttonCallable = buttonCallable.bind(b_index)
		buttonLvup.connect("pressed", buttonCallable)

func connect_event_inv_slots():
	for i in range(inv_panel.get_child_count()):
		var Invslot = inv_panel.get_child(i)
		var slotCallable = Callable(_on_mouse_slot_clicked)
		slotCallable = slotCallable.bind(i)
		Invslot.connect("button_down", slotCallable)
		
		var SlotRelease = Callable(_on_mouse_released)
		SlotRelease = SlotRelease.bind(i)
		Invslot.connect("mouse_entered", SlotRelease)


func connect_event_inv_button():
	var inv_button = title_container.get_node("inv_button")
	inv_button.connect("pressed", _on_inv_button_pressed)

func connect_event_grimoire_slots():
	get_grimoire_slots()
	
	if grimoire_slots.size() == 0:
		print("No grimoire slots found")
		return
		
	for i in range(grimoire_slots.size()):
		var _gSlot = grimoire_slots[i]
		 
		var gSlotCallable = Callable(_on_mouse_grimoire_slot)
		gSlotCallable = gSlotCallable.bind(i)
		_gSlot.connect("mouse_entered", gSlotCallable)
		
		var gExitCallable = Callable(_on_mouse_exited)
		gExitCallable = gExitCallable.bind(i)
		_gSlot.connect("mouse_exited", gExitCallable)


func _on_skill_button_pressed(i: int):
	ItemGlobals.secondary_skill_active = false
	ItemGlobals.primary_skill_active = true
	inv_panel.hide()
	title_container.get_node("inv_name").hide()
	title_container.get_node("inv_button").show()
	title_container.get_node("skill_name").show()
	passive_container.show()
	clear_passive_cards()
	set_grimoire_slots(i)
	show_skill_info(i)
	print("skill pressed on primary weapon panel")


func _on_levelup_button_pressed(i: int):
	_skill_levelup(i)
	print("button lvup on primary weapon panel")


func _skill_levelup(index: int):
	# Se o nível da skill for menor que o nível máximo dela, então aumenta o nível em 1 ponto
	if skill_tree[index] != null and skill_tree[index].skill_level < skill_tree[index].skill_max_level:
		skill_tree[index].skill_level += 1
		update_skill_tree_panel()

func show_skill_info(index: int):
	get_grimoire_slots()
	get_equiped_grimoires()


func set_grimoire_slots(index: int):
	GrimoireSlots = skill_tree[index].grimoire_Slots


func get_grimoire_slots():
	for i in range(skill_info_panel.get_child_count()):
		if skill_info_panel.get_child(i) is TextureButton:
			var g = skill_info_panel.get_child(i)
			grimoire_slots.append(g)


func get_equiped_grimoires():
	for g_slot in range(GrimoireSlots.size()):
		var grimoire_slot = grimoire_slots[g_slot]
		var g_icon = grimoire_slot.get_child(0)
		
		if GrimoireSlots[g_slot] != null:
			g_icon.texture = GrimoireSlots[g_slot].grimoire_icon
			get_grimoire_passives(g_slot)
		else:
			g_icon.texture = null


func clear_passive_cards():
	for child in passive_container.get_children():
		if child is Panel:
			passive_container.remove_child(child)
			child.queue_free()


func get_grimoire_passives(slot: int):
	var passive = skill_passive_scene.instantiate()
	var grimoire_passive = GrimoireSlots[slot].grimoire_passive
	
	var passive_title = passive.get_child(0).get_node("name")
	var passive_icon = passive.get_child(0).get_node("passive_icon")
	#var passive_desc = passive.get_node("desc_container").find_child("passive_desc")
	var passive_effect = passive.get_node("desc_container").find_child("passive_effect")
	
	passive_title.text = grimoire_passive.passive_name
	passive_icon.texture = grimoire_passive.Passive_icon
	#passive_desc.text = grimoire_passive.passive_desc
	passive_effect.text = grimoire_passive.passive_effect
	
	
	passive_container.add_child(passive)


func _on_inv_button_pressed() -> void:
	if not ItemGlobals.secondary_skill_active:
		title_container.get_node("inv_button").hide()
		passive_container.hide()
		inv_panel.show()
		print(weapon_type)


func _on_mouse_slot_clicked(slot_index: int):
	if inv_panel.GrimoireInv[slot_index] != null and not ItemGlobals.secondary_skill_active:
		slotReleaseIndex = slot_index
		is_dragging = true
		dragging_item = inv_panel.GrimoireInv[slot_index]
		inv_panel.GrimoireInv[slot_index] = null
		grimoireInvSlotIndex_from_dragg = slot_index
		_on_dragging_grimoire(slot_index)
		print("index from drag: " + str(grimoireInvSlotIndex_from_dragg))
		print("slot clicked " + str(dragging_item.grimoire_name))


func _input(event: InputEvent) -> void:
	if event.is_action_released("mouse_left") and not ItemGlobals.secondary_skill_active:
		if is_dragging:
			if gSlotReleasedIndex != null:
				release_dragged_item_on_grimoire_slot(gSlotReleasedIndex)
				return
			else:
				release_dragged_item(slotReleaseIndex)
				return
			
			
func _on_mouse_released(slot_index: int):
	if dragging_item != null:
		slotReleaseIndex = slot_index
		print(slot_index)


func _on_mouse_grimoire_slot(slot_index: int):
	if dragging_item != null and not ItemGlobals.secondary_skill_active:
		gSlotReleasedIndex = slot_index
		print("passei aqui " + str(gSlotReleasedIndex))


func _on_dragging_grimoire(index: int):
	dragging_preview.show()
	dragging_preview.texture = dragging_item.grimoire_icon
	var _slot = inv_panel.get_child(index)
	_slot.get_child(0).texture = null
	print("dragging")


func release_dragged_item(index: int) -> void:
	if inv_panel.GrimoireInv[index] == null and not ItemGlobals.secondary_skill_active:
		is_dragging = false
		dragging_preview.hide()
		inv_panel.GrimoireInv[index] = dragging_item
		dragging_item = null
		
		print("item draged on slot " + str(index))
		inv_panel.get_grimoire_slot_inv()

	elif inv_panel.GrimoireInv[index] != null and not ItemGlobals.secondary_skill_active:
		print("index from drag: " + str(grimoireInvSlotIndex_from_dragg))
		is_dragging = false
		dragging_preview.hide()
		inv_panel.GrimoireInv[grimoireInvSlotIndex_from_dragg] = inv_panel.GrimoireInv[index]
		inv_panel.GrimoireInv[index] = dragging_item
		dragging_item = null
		inv_panel.get_grimoire_slot_inv()
		print("item draged de volta no slot " + str(grimoireInvSlotIndex_from_dragg))


func release_dragged_item_on_grimoire_slot(index: int):
	if GrimoireSlots[index] == null and not ItemGlobals.secondary_skill_active:
		is_dragging = false
		dragging_preview.hide()
		GrimoireSlots[index] = dragging_item
		dragging_item = null
		
		get_equiped_grimoires()
		inv_panel.get_grimoire_slot_inv()
		print("item draged on grimoire slot " + str(index))
		
	elif GrimoireSlots[index] != null and not ItemGlobals.secondary_skill_active:
		slotReleaseIndex = null
		print("index from drag: " + str(grimoireInvSlotIndex_from_dragg))
		is_dragging = false
		dragging_preview.hide()
		inv_panel.GrimoireInv[grimoireInvSlotIndex_from_dragg] = dragging_item
		dragging_item = null
		
		get_equiped_grimoires()
		inv_panel.get_grimoire_slot_inv()

func _on_mouse_exited(index: int):
	gSlotReleasedIndex = null
	print("ops! Saí!")
