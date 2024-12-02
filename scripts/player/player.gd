extends CharacterBody2D

class_name Player

@export var navigation_component: NavigationAgent2D
@export var take_dmg: Node2D
@export var input_component: Node2D
@export var animation_component: Node2D
@export var dash_component: Node2D
@export var SPEED = 300.0
@export var hp: int
@export var jumping: bool

var action_keys = {
	"attack": "basic_attack",
	"block": "block",
	"inventory": "inventory",
	"map": "map",
	"hotbar_1": "hotbar_1",
	"hotbar_2": "hotbar_2"
}

func _ready() -> void:
	load_keybindings()
	$sprite2.hide()
	GLobals.connect("cam_shake", _on_cam_shake)

func _physics_process(delta):
	# Chama a função do nó para checar os inputs
	input_component.get_input(Input)
	if not GLobals.target:
		get_node("basic_attack").is_attacking = false
		#SPEED = 650
		return
	
func _on_destination_reached() -> void:
	# Se o node cehgou ao destino, define a velocidade para 0 e define o estado para "idle"
	if dash_component.is_dashing:
		dash_component.end_dash()

	velocity = Vector2.ZERO
	#animation_component.state_machine.dispatch(&"to_idle")

func _on_cam_shake(intensity, duration):
	$sprite/cam.apply_shake(duration, intensity)
	await get_tree().create_timer(duration).timeout
	$sprite/cam.position_smoothing_enabled = true
	
func receive_dmg(damage: int, attacker: Node, target: Node, anim: String):
	take_dmg.apply_dmg_popup(damage, attacker, target, anim)

func load_keybindings():
	var config = ConfigFile.new()
	if config.load("res://config/keybindings.cfg") == OK:
		for action in action_keys.keys():
			var scancode = config.get_value("keybindings", action_keys[action], null)
			if scancode:
				var key_event = InputEventKey.new()
				key_event.keycode = scancode
				InputMap.action_erase_events(action_keys[action])
				InputMap.action_add_event(action_keys[action], key_event)
				print(scancode)
