extends Control

var action_keys = {
	"attack": "basic_attack",
	"block": "block",
	"inventory": "inventory",
	"map": "map",
	"hotbar_1": "hotbar_1",
	"hotbar_2": "hotbar_2"
}

func save_keybindings():
	# Verifica se o arquivo já existe e o remove
	var dir = DirAccess.open("res://")
	if dir.file_exists("res://config/keybindings.cfg"):
		var err = dir.remove("res://config/keybindings.cfg")
		if err != OK:
			print("Erro ao remover o arquivo anterior: ", err)
		else:
			print("Arquivo de keybindings anterior removido com sucesso.")
	
	var config = ConfigFile.new()
	
	for action in action_keys.keys():
		var key_event = InputMap.action_get_events(action_keys[action])[0]
		if key_event is InputEventKey:
			print("Salvando ação: ", action_keys[action], " com scancode: ", key_event.keycode)
			config.set_value("keybindings", action_keys[action], key_event.keycode)
	config.save("res://config/keybindings.cfg")
	

func load_keybindings():
	var config = ConfigFile.new()
	if config.load("res://config/keybindings.cfg") == OK:
		for action in action_keys.keys():
			var scancode = config.get_value("keybindings", action_keys[action], null)
			
			if scancode != null:
				var key_event = InputEventKey.new()
				key_event.keycode = scancode
				InputMap.action_erase_events(action_keys[action])
				InputMap.action_add_event(action_keys[action], key_event)
				
				print("Carregando keybindings..." + str(scancode))
				
	else:
		print("Nenhum arquivo de keybindings encontrado, usando padrões.")
