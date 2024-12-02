extends Node

class_name SkillManager

@export var hotbar_skills: Array[GDSkillData]

var clicked: bool = true
var key_released: bool = false
var can_skill: bool = true
var cast_started: bool = false

var skill_instance: Node = null

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
				
				if skill_data.cast_time == 0:
					skill_instance.use_skill(player, skill_data.dmg_amount, skill_data.cooldown, target)
				
					if skill_data.is_aim_skill and clicked == true and skill_data.cooldown_left <= 0:
						skill_data.cooldown_left = skill_data.cooldown
						print("cooldown iniciado")
						clicked = false
					elif skill_data.is_charging_skill and clicked == true and skill_data.cooldown_left <= 0:
						key_released = false
					elif skill_data.insta_cast_skill and skill_data.cooldown_left <= 0:
						skill_data.cooldown_left = skill_data.cooldown
					elif skill_data.is_target_skill and skill_data.cooldown_left <= 0 and GLobals.target:
						skill_data.cooldown_left = skill_data.cooldown
					
				
				if skill_data.cast_time > 0:
					skill_instance.use_skill(player, skill_data.dmg_amount, skill_data.cooldown, skill_data.cast_time, target)
					if skill_data.is_charging_skill and skill_data.cooldown_left <= 0:
						cast_started = true
						skill_data.cast_left = skill_data.cast_time
					elif skill_data.is_cast_skill and skill_data.cooldown_left <= 0:
						key_released = false

func cancel_skill(skill_id: int):
	for skill in hotbar_skills:
		if skill != null and skill.id == skill_id:
			var skill_data = skill
			if skill_instance != null and skill_instance.has_method("cancel_skill"):
				if skill_instance != null and skill.is_cast_skill:
					GLobals.emit_signal("key_skill_released", skill_id)
					skill_instance.cancel_skill()
					skill_id = -1
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
