extends Node

class_name SkillManager

@export var hotbar_skills: Array[GDSkillData]

var clicked: bool = true
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
	cooldown_process(delta)
	
	if cast_started:
		cast_process(delta)


func cooldown_process(delta: float):
	for skill_data in hotbar_skills:
		if skill_data != null:
			if skill_data.cooldown_left > 0:
				skill_data.cooldown_left -= delta
				if skill_data.cooldown_left < 0:
					skill_data.cooldown_left = 0
					print("A skill está pronta para uso novamente!")
					for skill in used_skills:
						if skill == skill_data:
							used_skills.erase(skill)

func cast_process(delta: float):
	for skill_data in hotbar_skills:
		if skill_data != null:
			if skill_data.cast_left > 0:
				skill_data.cast_left -= delta
				if skill_data.cast_left <= 0:
					skill_data.cast_left = 0
					cast_started = false # reset cast time
					print("Cast finalizado")
					cancel_skill(skill_data.id)
				print(skill_data.cast_left)

func activate_skill(skill_id: int, player: CharacterBody2D, target: Node = null):
	for skill in hotbar_skills:
		if skill != null and skill.id == skill_id:
			var skill_data = skill
			
			if skill_data != null:
				if skill_data.cooldown_left > 0:
					print("A skill estará disponível para uso novamente em: " + str(skill_data.cooldown_left) + "sec")
					return
				
				skill_instance = skill_data.skill_effect.instantiate()
				get_parent().add_child(skill_instance)
				
				if skill_data.cast_time == 0 and not skill_data.is_target_skill:
					skill_instance.use_skill(player, skill_data.dmg_amount, skill_data.cooldown, target)
				
					if skill_data.is_aim_skill and clicked == true and skill_data.cooldown_left <= 0:
						skill_data.cooldown_left = skill_data.cooldown
						print("cooldown iniciado")
						clicked = false
					elif skill_data.is_charging_skill and clicked == true and skill_data.cooldown_left <= 0:
						key_released = false
					elif skill_data.insta_cast_skill and skill_data.cooldown_left <= 0:
						if skill_data.max_skill_charges > 0:
							if skill_data.skill_charges == skill_data.max_skill_charges:
								skill_data.cooldown_left = skill_data.cooldown
								skill_data.skill_charges = 1
							else:
								skill_data.cooldown_left = 1.0
								skill_data.skill_charges += 1
							
						if last_used_skill_ID != null:
							verify_skill_interactions(last_used_skill_ID, skill_data)
						
						last_used_skill_ID = skill_data
				
				if skill_data.cast_time == 0 and skill_data.is_target_skill:
					if GLobals.target != null:
						skill_instance.use_skill(player, skill_data.dmg_amount, skill_data.cooldown, target)
						if skill_data.is_target_skill and skill_data.cooldown_left <= 0 and GLobals.target:
							if last_used_skill_ID != null:
								verify_skill_interactions(last_used_skill_ID, skill_data)
								
							skill_data.cooldown_left = skill_data.cooldown
							last_used_skill_ID = skill_data
							#skill_data.skill_states.USED
					
				
				if skill_data.cast_time > 0:
					skill_instance.use_skill(player, skill_data.dmg_amount, skill_data.cooldown, skill_data.cast_time, target)
					if skill_data.is_charging_skill and skill_data.cooldown_left <= 0:
						cast_started = true
						skill_data.cast_left = skill_data.cast_time
					elif skill_data.is_cast_skill and skill_data.cooldown_left <= 0:
						key_released = false
						
						

func verify_skill_interactions(last_skill_ID: GDSkillData, skill_data: GDSkillData):
	if skill_data.skill_interaction_effects.size() > 0:
		for effect in skill_data.skill_interaction_effects:
			if effect.Skill_ID == last_skill_ID.id:
				apply_skill_effect(effect.Skill_effects, last_skill_ID, effect.Percentage)
			else:
				for skill in used_skills:
					if skill.id == effect.Skill_ID:
						if skill.skill_states == 1:
							apply_skill_effect(effect.Skill_effects, skill, effect.Percentage)
	
			
func apply_skill_effect(skill_effect: SkillINteractionsData.Effects, last_skill_data: GDSkillData, percentage: float):
		match skill_effect:
			SkillINteractionsData.Effects.COOLDOWN_REDUCTION:
				print("cooldown reduzido")
				if last_skill_data.cooldown_left > 0:
					var total_cooldown = last_skill_data.cooldown *(1 - percentage / 100)
					last_skill_data.cooldown_left = max(0, min(total_cooldown, last_skill_data.cooldown_left * (total_cooldown / last_skill_data.cooldown)))
			SkillINteractionsData.Effects.LIFESTEAL:
				print("curando em 2,5% do dano causado")
				
		

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
						verify_skill_interactions(last_used_skill_ID, skill_data)
						
				elif skill_instance != null and skill.is_charging_skill:
					GLobals.emit_signal("key_skill_released", skill_id)
					skill_instance.cancel_skill()
					skill_id = -1
			
			

func _on_clicked_aim_skill():
	print("clicked")
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
				elif skill.is_cast_skill:
					if key_released:
						skill.cooldown_left = skill.cooldown
						print("cooldown iniciado")
						
