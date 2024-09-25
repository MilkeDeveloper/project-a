extends Node2D

var damage 
var attacker
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$anim.play("Explosion")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	
func start_shake():
	GLobals.emit_signal("cam_shake", 3.5, 0.5)





func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage, attacker, body, "magic_hit")
