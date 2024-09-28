extends Node2D

@export var explosion_scene : PackedScene

var target_position: Vector2
var speed_duration: float
var max_range: float
var attacker
var damage
var direction
var origin_position: Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	 # Replace with function body.
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if global_position.distance_to(target_position) <= 10:
		_on_destroy()
	# Move o projétil na direção do alvo
	global_position += direction * speed_duration * delta
	
func launch_fireball(target: Vector2, duration: float):
	target_position = target
	speed_duration = duration
	self.look_at(target_position)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("entity"):
		pass

func _on_destroy():
	var explosion = explosion_scene.instantiate()
	explosion.position = global_position
	explosion.damage = damage * 15
	explosion.attacker = attacker
	get_parent().get_tree().current_scene.add_child(explosion)
	queue_free()
