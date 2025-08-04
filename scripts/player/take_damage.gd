extends Node2D

@export var dmgPop: PackedScene
@export var entity: CharacterBody2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func apply_dmg_popup(damage: int, attacker: Node, target: Node, popup_anim: String):
	var dmg_popup = dmgPop.instantiate()
	dmg_popup.global_position = entity.global_position
	randomize()
	dmg_popup.position.x = global_position.x + randi_range(-16, 16)
	dmg_popup.position.y = global_position.y + randi_range(12, 12)
	entity.get_parent().add_child(dmg_popup)
	
	dmg_popup.start_popup2(damage, popup_anim, attacker, self)
	
	if entity.is_skill_charging or entity.get_node("dash_component").is_dashing:
		print("ignore hurt")
	else:
		entity.get_node("navigation").set_process(false)
		await get_tree().create_timer(0.2).timeout
		entity.get_node("navigation").set_process(true)
	
	
