# SkillFlowManager.gd
extends Node

var current_handler = null
var handlers = {}

func _ready():
	pass 

func start_skill_flow(skill_data, player, target):
	var type = skill_data.skill_type # Exemplo: "cast", "aim", "charge"
	current_handler = handlers.get(type)
	if current_handler:
		current_handler.start(skill_data, player, target)

func _process(delta):
	if current_handler:
		current_handler.update(delta)

func finish_skill_flow():
	if current_handler:
		current_handler.finish()
		current_handler = null
