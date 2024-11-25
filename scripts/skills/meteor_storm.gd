extends SkillBase

class_name MeteorStorm

@export var projectile_num : int
@export var time_between_projectiles : float
@export var random_area: int



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	selector.hide()
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		selector.global_position = get_global_mouse_position()
		
		if Input.is_action_just_pressed("mouse_left"):
			mouse_position = get_global_mouse_position()
			selector.hide()
			cast_skill = true
			
			launch_meteor()
			GLobals.emit_signal("on_click")
		
		
func use_skill(_player, skill_damage, _cooldown, _cast_time, target = null):
	damage = skill_damage
	cooldown = _cooldown
	_target = target
	player = _player
	selector.show()
	print("castando")
	set_process(true)

func launch_meteor():
	if not cast_skill and not player:
		return
	
	for projectile in projectile_num:
		_handle_anim()
		var meteor = Projectile.instantiate()
		randomize()
		meteor.global_position.x = mouse_position.x + randi_range(-random_area, random_area)
		meteor.global_position.y = mouse_position.y + randi_range(-random_area, random_area)
		meteor.damage = damage / 10
		meteor.attacker = player
		get_tree().current_scene.add_child(meteor)
		await get_tree().create_timer(time_between_projectiles).timeout
	
	print(cast_skill)
	cast_skill = false
	set_process(false)
	queue_free()

func cancel_skill():
	pass

func _input(event: InputEvent) -> void:
	pass
		
		
func _handle_anim():
	player.get_node("anim").play("idle_" + player.get_node("DirectionTracker").get_action_direction(mouse_position))
