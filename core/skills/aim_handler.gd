# AimSkillHandler.gd
extends SkillHandler

var aiming = false

func start(skill_data, player, target):
	aiming = true
	print("Iniciando aiming para skill ", skill_data.name)
	# aqui você poderia mostrar o seletor e esperar input

func update(delta):
	if aiming:
		pass
		# atualiza posição do seletor com mouse, etc

func finish():
	aiming = false
	print("Aiming finalizado, executando skill")
	# chama ativação da skill, cooldown etc
