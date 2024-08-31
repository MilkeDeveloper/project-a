extends Node2D

@export var navigation_component:  NavigationAgent2D


# Checa os inputs do player
func get_input(event):
	if event.is_action_pressed("mouse_left"):
		# Chama a função do NavigationComponent2D para definir o destino
		navigation_component.set_destination(get_global_mouse_position())
		
