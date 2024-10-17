extends Panel


@export var WeaponSkillTrees: SkillWeaponClass
@export var GrimoireSlots: Array[SkillCardData]
@export var inv_panel: GridContainer
@export var skill_info_panel: Panel
@export var passive_container: VBoxContainer
@export var title_container: Panel
@export var dragging_preview: TextureRect
@export var skill_passive_scene: PackedScene
@export var weapon_type: String
@export var spec_alert: Panel
@export var weapon_class_name: Label
@export var spec: HBoxContainer


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
var last_click = 0
var double_click_time = 0.2
var skill_index: int

func _ready() -> void:
	get_primary_weapon_skills_ui_slot()
	update_skill_tree_panel()
	get_callable_buttons()
	connect_event_inv_slots()
	connect_event_grimoire_slots()
	connect_event_inv_button()
	connect_spec_signals()

func _process(delta: float) -> void:
	if is_dragging:
		dragging_preview.global_position = get_global_mouse_position() - dragging_preview.size / 2
		
func _clear_dragged_item():
	dragging_item = null

func update_skill_tree_panel():
	if SkillMenuGlobals.current_skill_tree2 == "Wand":
		weapon_class_name.text = "Wand Skills"
		skill_tree = WeaponSkillTrees.Wand
		load_weapon_skill_tree(WeaponSkillTrees.Wand)
	else:
		if spec.secondary_spec[0] != null:
			var weapon_spec = spec.secondary_spec[0].spec
			weapon_class_name.text = weapon_spec.spec_name
			skill_tree = weapon_spec.spec_skills
			load_weapon_skill_tree(weapon_spec.spec_skills)

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
			button_index[i].disabled = false
			button_index[i].texture_normal = skill_tree[i].skill_icon
			button_index[i].get_child(0).show()
			var skilLv_text = button_index[i].get_child(0).get_node("Label")
			skilLv_text.text = str(skill_tree[i].skill_level) + "/" + str(skill_tree[i].skill_max_level)
		else:
			button_index[i].texture_normal = load("res://assets/misc/hotbar_slot_remake.png")
			button_index[i].disabled = true
			button_index[i].get_child(0).hide()

func connect_spec_signals():
	SkillMenuGlobals.clear_dragged_item.connect(_clear_dragged_item)

func connect_event_inv_button():
	var inv_button = title_container.get_node("inv_button")
	inv_button.connect("pressed", _on_inv_button_pressed)

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
	skill_index = i
	spec_alert.hide()
	ItemGlobals.primary_skill_active = false
	ItemGlobals.secondary_skill_active = true
	SkillMenuGlobals.curent_primary_skill_selected = false
	SkillMenuGlobals.curent_secondary_skill_selected = true
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

func clear_grimoire_slots():
	for g_slot in range(GrimoireSlots.size()):
		var grimoire_slot = grimoire_slots[g_slot]
		var g_icon = grimoire_slot.get_child(0)
		grimoire_slot.hide()


func get_equiped_grimoires():
	for g_slot in range(GrimoireSlots.size()):
		var grimoire_slot = grimoire_slots[g_slot]
		var g_icon = grimoire_slot.get_child(0)
		
		if GrimoireSlots[g_slot] != null:
			g_icon.texture = GrimoireSlots[g_slot].card_icon
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
	var grimoire_passive = GrimoireSlots[slot].card_passive
	
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
	if not ItemGlobals.primary_skill_active:
		title_container.get_node("inv_button").hide()
		passive_container.hide()
		inv_panel.show()
		print(weapon_type)


func _on_mouse_slot_clicked(slot_index: int):
	var current_time = Time.get_ticks_msec() / 1000
	
	if inv_panel.GrimoireInv[slot_index] != null and current_time - last_click <= double_click_time and not ItemGlobals.primary_skill_active:
		print("double_click")
		_on_dragging_grimoire(slot_index)
		_on_double_click(slot_index)
	else:
		last_click = current_time
		click_to_dragg(slot_index)
		

func click_to_dragg(slot_index: int):
	if inv_panel.GrimoireInv[slot_index] != null and not ItemGlobals.primary_skill_active:
		slotReleaseIndex = slot_index
		is_dragging = true
		dragging_item = inv_panel.GrimoireInv[slot_index]
		
		#if dragging_item is SkillCardData:
			#SkillMenuGlobals.on_grimoire_clicked.emit(dragging_item, slotReleaseIndex)
		
		_on_dragging_grimoire(slot_index)
		inv_panel.GrimoireInv[slot_index] = null
		grimoireInvSlotIndex_from_dragg = slot_index
		print("index from drag: " + str(grimoireInvSlotIndex_from_dragg))
		if inv_panel.GrimoireInv[slot_index] is SkillCardData:
			print("slot clicked " + str(dragging_item.card_name))
		elif inv_panel.GrimoireInv[slot_index] is SpecGrimoireData:
			print("slot clicked " + str(dragging_item.grimoire_name))
			

func _input(event: InputEvent) -> void:
	if event.is_action_released("mouse_left") and not ItemGlobals.primary_skill_active:
		if is_dragging:
				release_dragged_item(slotReleaseIndex)
				return

func release_dragged_item(index: int) -> void:
	
	if inv_panel.GrimoireInv[index] == null and not ItemGlobals.primary_skill_active:
		is_dragging = false
		dragging_preview.hide()
		inv_panel.GrimoireInv[index] = dragging_item
		dragging_item = null
			
		print("item draged on slot " + str(index))
		inv_panel.get_grimoire_slot_inv()

	elif inv_panel.GrimoireInv[index] != null and not ItemGlobals.primary_skill_active:
		print("index from drag: " + str(grimoireInvSlotIndex_from_dragg))
		is_dragging = false
		dragging_preview.hide()
		inv_panel.GrimoireInv[grimoireInvSlotIndex_from_dragg] = inv_panel.GrimoireInv[index]
		inv_panel.GrimoireInv[index] = dragging_item
		dragging_item = null
		inv_panel.get_grimoire_slot_inv()
		print("item draged de volta no slot " + str(grimoireInvSlotIndex_from_dragg))


func _on_mouse_released(slot_index: int):
	if dragging_item != null:
		slotReleaseIndex = slot_index
		print(slot_index)


func _on_mouse_grimoire_slot(slot_index: int):
	if dragging_item != null and not ItemGlobals.primary_skill_active:
		gSlotReleasedIndex = slot_index
		print("passei aqui " + str(gSlotReleasedIndex))


func _on_dragging_grimoire(index: int):
	dragging_preview.show()
	if inv_panel.GrimoireInv[index] is SkillCardData:
		dragging_preview.texture = inv_panel.GrimoireInv[index].card_icon
	elif inv_panel.GrimoireInv[index] is SpecGrimoireData:
		dragging_preview.texture = inv_panel.GrimoireInv[index].grimoire_icon
		
	var _slot = inv_panel.get_child(index)
	_slot.get_child(0).texture = null
	print("dragging")


func _on_mouse_exited(index: int):
	gSlotReleasedIndex = null
	print("ops! Saí!")


func _on_double_click(_index: int):
	if inv_panel.GrimoireInv[_index] is SpecGrimoireData and SkillMenuGlobals.current_secondary_spec_slot_selected:
		SkillMenuGlobals.on_grimoire_clicked2.emit(inv_panel.GrimoireInv[_index], _index)
		dragging_preview.hide()
	elif inv_panel.GrimoireInv[_index] is SkillCardData and SkillMenuGlobals.curent_secondary_skill_selected:
		equip_card_on_skill(_index)
	#inv_panel.GrimoireInv[slot_index] = null
	else:
		dragging_preview.hide()
		inv_panel.GrimoireInv[_index] = inv_panel.GrimoireInv[_index]
		inv_panel.get_grimoire_slot_inv()

func equip_card_on_skill(_index: int):
	GrimoireSlots = skill_tree[skill_index].grimoire_Slots
	for i in range(GrimoireSlots.size()):
		if GrimoireSlots[i] == null and inv_panel.GrimoireInv[_index] is SkillCardData:
			is_dragging = false
			GrimoireSlots[i] = inv_panel.GrimoireInv[_index]
			inv_panel.GrimoireInv[_index] = null
			dragging_preview.hide()
			inv_panel.get_grimoire_slot_inv()
			get_equiped_grimoires()
			return
		else:
			print("não há slot disponível para equipar a carta")
			dragging_preview.hide()
			inv_panel.GrimoireInv[_index] = inv_panel.GrimoireInv[_index]
			inv_panel.get_grimoire_slot_inv()
