extends Node

class_name SkillManager

@export var hotbar_skills: Array[GDSkillData]

@export_category("Managers")
@export var validator: ValidatorManager
@export var cooldowns: CoolddownManager
@export var activator: ActivatorManager
@export var interactions: InteractionsManager
@export var cast: CastManager

var clicked: bool = false
var key_released: bool = false
var can_skill: bool = true
var cast_started: bool = false

var skill_instance: Node = null
var last_used_skill_ID: GDSkillData
var used_skills: Array[GDSkillData]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GLobals.on_click.connect(_on_clicked_aim_skill)
	GLobals.key_skill_released.connect(_on_key_skill_released)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if cast and cooldowns and activator:
		cast.update_cast(delta)
		cooldowns.update_cooldowns(delta)
		activator.update_skill_instance(delta)

func activate_skill(skill_id: int, player: CharacterBody2D, target: Node = null):
	if player.is_attacking:
		return
		
	for skill in hotbar_skills:
		if skill != null and skill.id == skill_id:
			var skill_data = skill
			
			if skill_data:
				if skill_data.spell_type == skill_data.SpellType.AIM:
					if validator.can_use_skill(skill_data, player, cooldowns, target):
						cast.start_cast(skill_data)
						activator.instantiate_skill(skill_data, player, target)
						
					else:
						print("Não é possível usar a skill " + skill_data.skill_name + " no momento")
				else:
					if validator.can_use_skill(skill_data, player, cooldowns, target):
						cast.start_cast(skill_data)
						activator.instantiate_skill(skill_data, player, target)
						cooldowns.start_cooldown(skill_data)
					else:
						print("Não é possível usar a skill " + skill_data.skill_name + " no momento")

func cancel_skill(skill_id: int):
	for skill in hotbar_skills:
		if skill != null and skill.id == skill_id:
			var skill_data = skill
			if skill_instance != null and skill_instance.has_method("cancel_skill"):
				if skill_instance != null and skill.is_cast_skill and skill.cast_left <= 0:
					GLobals.emit_signal("key_skill_released", skill_id)
					skill_instance.cancel_skill()
					last_used_skill_ID = skill_data
					skill_data.skill_states = 1
					used_skills.append(skill_data)
					
					if last_used_skill_ID != null:
						interactions.verify_skill_interactions(last_used_skill_ID, skill_data)
						
				elif skill_instance != null and skill.is_charging_skill:
					GLobals.emit_signal("key_skill_released", skill_id)
					skill_instance.cancel_skill()
					skill_id = -1

func _on_clicked_aim_skill():
	clicked = true
	
func _on_key_skill_released(skill_id: int) -> void:
	print("Key_released")
	key_released = true
	reset_charging_skill(skill_id)

func reset_charging_skill(skill_id: int):
	for skill_data in hotbar_skills:
		if skill_data != null:
			if skill_data.id == skill_id:
				var skill = skill_data
				
				if skill.is_charging_skill:
					if key_released:
						skill.cooldown_left = skill.cooldown
						print("cooldown iniciado")
				elif skill.is_cast_skill and skill.cooldown_left <= 0:
					if key_released:
						skill.cooldown_left = skill.cooldown
						print("cooldown iniciado")
