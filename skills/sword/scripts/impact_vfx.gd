extends Node2D

class_name ImpactVFX

@export var crack: Sprite2D
@export var area: Area2D
@export var effect: AnimationPlayer

var data: Dictionary = {
	"damage": 100,
	"attacker": null
}

func _ready() -> void:
	effect.play("ground_impact_vfx")
	await get_tree().create_timer(5.0).timeout
	clear_cracks()
	
	
func clear_cracks():
	var tween = get_tree().create_tween()
	tween.tween_property(crack, "modulate", Color(1, 1, 1, 0), 1.0)
	
	await tween.finished
	queue_free()

func get_dmg_data(_data: Dictionary ):
	data = _data

func _on_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("entity"):
		if body.has_method("take_damage"):
			body.take_damage(data["damage"], data["attacker"], body, "magic_hit")
			area.queue_free()
