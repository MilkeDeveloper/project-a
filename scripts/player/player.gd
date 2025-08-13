extends CharacterBody2D

class_name Player

@onready var instant_bar = get_node("sprite/hud_player/hp_bar")
@onready var delay_bar = get_node("sprite/hud_player/daleyed_hpbar")
@onready var regen_timer = $regen_timer
@onready var combat_timer = $combat_timer

@export var stats: EntityStats
@export var navigation_component: NavigationAgent2D
@export var take_dmg: Node2D
@export var input_component: Node2D
@export var animation_component: AnimationPlayer
@export var dash_component: Node2D
@export var SPEED = 300.0
@export var max_hp: int
@export var jumping: bool
@export var is_in_combat: bool
@export var delay_speed: float

var use_skill = false

var current_hp = 100
var delayed_hp = 100

var is_skill_charging: bool

var _attacker = null
var mouse_position
var can_move: bool = true
var is_attacking: bool = false

var is_dashing: bool = false


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
	
	current_hp = max_hp
	delayed_hp = max_hp
	
	update_bars()
	
	mouse_position = get_global_mouse_position()

func _physics_process(delta):
	# Chama a função do nó para checar os inputs
	input_component.get_input(Input)
	mouse_position = get_global_mouse_position()
	if not GLobals.target:
		get_node("basic_attack").is_attacking = false
		#SPEED = 650
		return

func _on_destination_reached() -> void:
	# Se o node cehgou ao destino, define a velocidade para 0 e define o estado para "idle"
	if dash_component.is_dashing:
		dash_component.end_dash()
	
	is_dashing = false

	velocity = Vector2.ZERO
	#animation_component.state_machine.dispatch(&"to_idle")

func _on_cam_shake(intensity, duration):
	$sprite/cam.apply_shake(duration, intensity)
	await get_tree().create_timer(duration).timeout
	$sprite/cam.position_smoothing_enabled = true
	
func receive_dmg(damage: int, attacker: Node, target: Node, anim: String):
	take_dmg.apply_dmg_popup(damage, attacker, target, anim)
	current_hp = max(current_hp - damage, 0)
	is_in_combat = true
	regen_timer.stop()
	update_bars()

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

func update_bars():
	var percent = float(current_hp) / max_hp
	if instant_bar != null:
		instant_bar.value = percent * 100
		#delay_bar.value será ajustado no _process()


func _process(delta):
	$hit_box.look_at(get_global_mouse_position())
	if delayed_hp > current_hp:
		delayed_hp = max(delayed_hp - delay_speed * delta, current_hp)
		var percent = float(delayed_hp) / max_hp
		delay_bar.value = percent * 100
		
	if is_in_combat:
		combat_range()
	
func hp_sp_regen():
	if not is_in_combat and current_hp < max_hp:
		current_hp = max(current_hp + (max_hp / 100), 0)
		delayed_hp = max(delayed_hp + (max_hp / 100), 0)
		update_bars()
		
	print(is_in_combat)
	
func combat_range():
	if Combat.enemy:
		_attacker = Combat.enemy
		if self.global_position.distance_to(_attacker.global_position) > 320:
			if not combat_timer.is_stopped():
				return
			combat_timer.start()
		else:
			regen_timer.stop()
			combat_timer.stop()
			
		

func _on_regen_timer_timeout() -> void:
	hp_sp_regen()


func _on_combat_timer_timeout() -> void:
	is_in_combat = false
	regen_timer.start()
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("entity"):
		#GLobals.emit_signal("cam_shake", 5.5, 0.5)
		if body.has_method("take_damage"):
			var dmg = get_node("basic_attack").basic_dmg
			body.take_damage(dmg, self, body, "magic_hit")
			TargetManager.set_target(body.map_npc_id)
			
