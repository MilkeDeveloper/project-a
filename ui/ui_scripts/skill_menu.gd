extends Panel

@export var WeaponSkillTrees: SkillWeaponClass
@export var GrimoireSlots: Array[SkillGrimoireData]
@export var GrimoireInv: Array[SkillGrimoireData]
@export var skill_tree = null
@export var skill_info_panel: Panel
@export var weapon_type: String
@export var skill_passive_scene: PackedScene
@export var passive_container: VBoxContainer
@export var inv_panel: GridContainer
@export var title_container: Panel

var skill_evolution_points = 1
var index: int = 0
var button_index 
var button_lvup_index 

var title_class: String
var grimoire_slot = null
var InvSlot = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_index = []
	button_lvup_index = []
	# Aqui percorremos todos os nós filhos do container para saber quantos ButtonTexture temos, e ncontrar seu respectivos índices
	for i in range(get_child_count()):
		if get_child(i) is TextureButton:
			# se o filho for um Texture Button, adicionamos ao array de btões
			var skill_button = get_child(i)
			button_index.append(skill_button)
			if skill_button.get_node("texture").get_child(1) is TextureButton:
				var button_lvup = get_child(i).get_node("texture").get_child(1)
				button_lvup_index.append(button_lvup)
				
	# Aqui conectamos os eventos dos botões
	connect_event_buttons()
	# Aqui obtemos a skill tree relacionado a cada tipo de arma
	get_skills_by_weapon_class(weapon_type)
	get_grimoire_slot_inv()

# Função para conectar os eventos do botões
func connect_event_buttons():
	# Aqui percorremos o array de botões para atribuir para que possamos conectar cada um
	for _index in range(button_index.size()):
		var skill_button = button_index[_index]
		# Essa variável é responsável pela conexão
		var callable = Callable(_on_skill_button_pressed)
		# Aqui usamos um bind para poder passar o parametro com o índice do botão clicado.
		callable = callable.bind(_index)
		skill_button.connect("pressed", callable)
	
	for b_index in range(button_lvup_index.size()):
		var buttonLvup = button_lvup_index[b_index]
		var buttonCallable = Callable(_on_levelup_button_pressed)
		buttonCallable = buttonCallable.bind(b_index)
		buttonLvup.connect("pressed", buttonCallable)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_levelup_button_pressed(index: int):
	_skill_levelup(index)

# Aqui é onde chamamos o evento de clique dos botões
func _on_skill_button_pressed(index: int):
	print("skill_pressed")
	inv_panel.hide()
	title_container.get_node("inv_name").hide()
	title_container.get_node("skill_name").show()
	passive_container.show()
	clear_passive_cards()
	show_skill_info(index)

func clear_passive_cards():
	for child in passive_container.get_children():
		if child is Panel:
			passive_container.remove_child(child)
			child.queue_free()
	
# Essa função é responsável por mostrar as informações da skill
func show_skill_info(skill_index: int):
	var grimoire_slots = []
	var skill = button_index[skill_index]
	# Se o slot da skill tree não estiver vazio, então mostramos as informações
	if skill_tree[skill_index] != null:
		for i in range(skill_info_panel.get_child_count()):
			if skill_info_panel.get_child(i) is TextureButton:
				var g = skill_info_panel.get_child(i)
				grimoire_slots.append(g)
	
		GrimoireSlots = skill_tree[skill_index].grimoire_Slots
		get_skill_equiped_grimoires(grimoire_slots)

func get_skill_equiped_grimoires(grimoire_slots: Array):
	for g_slot in range(GrimoireSlots.size()):
		grimoire_slot = grimoire_slots[g_slot]
		var g_icon = grimoire_slot.get_child(0)

		if GrimoireSlots[g_slot] != null:
			g_icon.texture = GrimoireSlots[g_slot].grimoire_icon
			get_grimoire_passives(g_slot)
		else:
			g_icon.texture = null

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

# Essa função é responsável por atualizar o contéudo apresentado no menu de skills
func update_skill_menu(index: int):
	var s_index = index
	var skill_button = button_index[index]
	# Se a skill é válida, então mostramos o icone dela e habilitamos suas funcionalidades
	if skill_tree[index] != null:
		skill_button.texture_normal = skill_tree[index].skill_icon
		skill_button.get_child(0).visible = true
		skill_button.get_child(0).get_node("Label").text = str(skill_tree[index].skill_level) + "/" + str(skill_tree[index].skill_max_level)
	
	# Aqui mostramos o título de acordo com a tipo da arma equipado atualmente
	var WeaponTitle = get_node("TitleClass")
	if WeaponTitle:
		WeaponTitle.text = title_class + " Skills"
	
# Essa função é responsável por aumentar o nível da skill
func _skill_levelup(index: int):
	# Se o nível da skill for menor que o nível máximo dela, então aumenta o nível em 1 ponto
	if skill_tree[index] != null and skill_tree[index].skill_level < skill_tree[index].skill_max_level:
		skill_tree[index].skill_level += 1
		update_skill_menu(index)

# Essa função é responsável por identificar as armas equipadas e exibir as a skill tree relacionada à elas
func get_skills_by_weapon_class(WeaponType: String):
	match WeaponType:
		"Staff":
			skill_tree = WeaponSkillTrees.Staff
		"Wand":
			skill_tree = WeaponSkillTrees.Wand
	title_class = WeaponType
	# Aqui iteramos sobre todos os botões para que cada um seja atualizado
	for i in range(button_index.size()):
		update_skill_menu(i)


func get_grimoire_slot_inv():
	for i in range(inv_panel.get_child_count()):
		update_grimoire_inv(i)
		
			
func update_grimoire_inv(index: int):
		InvSlot = GrimoireInv[index]
		
		var _slot = inv_panel.get_child(index)
		
		if InvSlot != null:
			_slot.get_child(0).texture = InvSlot.grimoire_icon
		
		
