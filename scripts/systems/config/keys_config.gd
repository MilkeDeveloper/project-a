extends HBoxContainer


@export var button: Button
@export var action_name: Label


# Dicionário para armazenar as teclas mapeadas para ações
@export var action_keys : Dictionary


# Armazena o botão que está sendo configurado
var current_button = null
var current_action = null

func _ready():
	# Inicializa a interface com as teclas atuais
	for action in action_keys:
		
		var events = InputMap.action_get_events(action_keys[action])
		
		action_name.text = action + ": "
		
		if events.size() > 0 and events[0] is InputEventKey:
			button.text = events[0].as_text()  # Mostra a tecla atual
		else:
			button.text = "Nenhuma tecla"

		# Armazena a ação no botão usando uma propriedade customizada
		button.set_meta("action", action)
		button.connect("pressed", Callable(self, "_on_key_button_pressed").bind(button))

func _on_key_button_pressed(button):
	# Obtemos o botão que foi pressionado usando o `Focus`
	
	current_button = button  # Armazena o botão que foi pressionado
	current_action = button.get_meta("action")  # Recupera a ação associada
	button.text = "Pressione uma tecla..."
	print("Pressione uma tecla para mapear para a ação: ", current_action)

	# Aguardamos o próximo evento de entrada
	set_process_input(true)

func _input(event):
	if event is InputEventKey and event.pressed and current_button:
		# Captura a tecla pressionada e a mapeia para a ação atual
		var key_event = InputEventKey.new()
		key_event.keycode = event.keycode

		# Atualiza o mapeamento da tecla para a ação atual
		InputMap.action_erase_events(action_keys[current_action])
		InputMap.action_add_event(action_keys[current_action], key_event)

		# Atualiza o texto do botão com a nova tecla
		current_button.text = key_event.as_text()
		
		#save_keybindings()

		# Finaliza o processo de captura de teclas
		current_button = null
		current_action = null
		set_process_input(false)
