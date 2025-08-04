extends Control

@onready var weapon_dropdown: OptionButton = $Panel/VBoxContainer/Weapons/WeaponDropdown
@onready var helmet_dropdown: OptionButton = $Panel/VBoxContainer/Helmet/HelmetDropdown
@onready var armor_dropdown: OptionButton = $Panel/VBoxContainer/Armor/ArmorDropdown
@onready var boots_dropdown: OptionButton = $Panel/VBoxContainer/Boots/BootsDropdown

@onready var combo_name: LineEdit = $Panel/VBoxContainer2/ComboName

@onready var modifier_dropdown: OptionButton = $Panel2/UltimateSkillEffect/EffectTypeDropdown
@onready var mod_value: SpinBox = $Panel2/UltimateSkillEffect/SpinValue
@onready var mod_duration: SpinBox = $Panel2/UltimateSkillEffect/SpinDuration
@onready var mod_chance: SpinBox = $Panel2/UltimateSkillEffect/SpinChance
@onready var mod_stack: SpinBox = $Panel2/UltimateSkillEffect/SpinStack

@onready var slider: HSlider = $VBoxContainer2/Effects
@onready var effect1: OptionButton = $VBoxContainer2/effect1
@onready var effect2: OptionButton = $VBoxContainer2/effect2
@onready var effect3: OptionButton = $VBoxContainer2/effect3
@onready var value1: SpinBox = $VBoxContainer2/value1
@onready var value2: SpinBox = $VBoxContainer2/value2
@onready var value3: SpinBox = $VBoxContainer2/value3


# (continue para outros dropdowns...)

var utils = preload("res://editors/utils/ResourceUtils.gd")

var weapons: Array = []
var helmets: Array = []
var armors: Array = []
var boots: Array = []
var set_effects: Array = []

func _ready():
	# Carrega armas e equipamentos
	
	weapons = utils.load_resources_from_folder("res://resources/weapons/", "GDWeaponData")
	helmets = utils.load_resources_from_folder("res://resources/equipments/helmets/", "EquipmentData")
	armors = utils.load_resources_from_folder("res://resources/equipments/armors/", "EquipmentData")
	boots = utils.load_resources_from_folder("res://resources/equipments/boots/", "EquipmentData")
	
	
	print(weapons)
	
	# Preenche dropdowns
	for i in weapons.size():
		weapon_dropdown.add_item(weapons[i].name, i)
	for i in helmets.size():
		helmet_dropdown.add_item(helmets[i].e_name, i)
	for i in armors.size():
		armor_dropdown.add_item(armors[i].e_name, i)
	for i in boots.size():
		boots_dropdown.add_item(boots[i].e_name, i)
		
	for effect in SetEffectsData.SetEffects:
		effect1.add_item(effect)
		effect2.add_item(effect)
		effect3.add_item(effect)
		
	slider.connect("value_changed", Callable(self, "_on_slider_changed"))
	_on_slider_changed(slider.value)
	
	# Conecta mudança de seleção
	weapon_dropdown.connect("item_selected", Callable(self, "_on_weapon_selected"))
	helmet_dropdown.connect("item_selected", Callable(self, "_on_helmet_selected"))
	armor_dropdown.connect("item_selected", Callable(self, "_on_armor_selected"))
	boots_dropdown.connect("item_selected", Callable(self, "_on_boots_selected"))

func _on_slider_changed(value):
	effect1.visible = value == 1
	effect2.visible = value == 2
	effect3.visible = value == 3
	value1.visible = value == 1
	value2.visible = value == 2
	value3.visible = value == 3
	


func _on_save_combo_presset_pressed():
	var combo = ComboBuildData.new()
	combo.name = combo_name.text
	combo.weapon = weapons[weapon_dropdown.selected]
	combo.armor = armors[armor_dropdown.selected]
	combo.helmet = helmets[helmet_dropdown.selected]
	combo.boots = boots[boots_dropdown.selected]
	
	
	if slider.value >= 1:
		var effect = SetEffectsData.new()
		effect.type = effect1.selected
		effect.percentage_value = value1.value
		combo.set_effects.append(effect)

	if slider.value >= 2:
		var effect = SetEffectsData.new()
		effect.type = effect2.selected
		effect.percentage_value = value2.value
		combo.set_effects.append(effect)

	if slider.value >= 3:
		var effect = SetEffectsData.new()
		effect.type = effect3.selected
		effect.percentage_value = value3.value
		combo.set_effects.append(effect)
	
		
	
	var modifier = GDSkillEffectData.new()
	
	modifier.type = modifier_dropdown.selected
	modifier.value = mod_value.value
	modifier.duration = mod_duration.value
	modifier.chance = mod_chance.value
	modifier.max_stacks = mod_stack.value
	
	combo.skill_e_modifier = modifier
	
	# Caminho onde você vai salvar o recurso
	var path = "res://resources/comboBuilds/%s.tres" % combo.name.strip_edges()

	var result = ResourceSaver.save(combo, path)
	if result == OK:
		print("Combo salvo com sucesso em: ", path)
	else:
		print("Erro ao salvar combo. Código: ", result)
