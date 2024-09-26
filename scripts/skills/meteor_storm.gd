extends SkillBase

class_name MeteorStorm

@export var projectile_num : int
@export var time_between_projectiles : float



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	selector.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		selector.global_position = get_global_mouse_position()
		
		
		
func use_skill(_player, skill_damage, _cooldown, anim_component, target):
	damage = skill_damage
	cooldown = _cooldown
	_target = target
	player = _player
	selector.show()
	print("castando")

func launch_meteor():
	if not cast_skill:
		return
	
	for projectile in projectile_num:
		var meteor = Projectile.instantiate()
		randomize()
		meteor.global_position.x = mouse_position.x + randi_range(-200, 200)
		meteor.global_position.y = mouse_position.y + randi_range(-150, 150)
		meteor.damage = damage / 10
		meteor.attacker = player
		get_tree().current_scene.add_child(meteor)
		await get_tree().create_timer(time_between_projectiles).timeout
	
	print(cast_skill)
	cast_skill = false
	queue_free()

func cancel_skill():
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_released("mouse_left"):
		mouse_position = get_global_mouse_position()
		selector.hide()
		cast_skill = true
		_handle_anim()
		launch_meteor()
		GLobals.emit_signal("on_click")
		
		
func _handle_anim():
	player.get_node("anim").play("idle_" + player.get_node("DirectionTracker").get_action_direction(mouse_position))
