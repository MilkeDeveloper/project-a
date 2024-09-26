extends Node2D

var damage
var attacker 

@export var explosion_scene : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$anim.play("fall")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_destroy():
	var explosion = explosion_scene.instantiate()
	explosion.position = global_position
	explosion.damage = damage
	explosion.attacker = attacker
	get_parent().get_tree().current_scene.add_child(explosion)
	queue_free()
