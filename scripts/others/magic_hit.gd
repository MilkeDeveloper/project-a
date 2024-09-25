extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_anim_animation_finished(anim_name: StringName) -> void:
	queue_free()

func start_animation(animation: String):
	$anim.play(animation)
	var sfx = randi_range(0, 1)
	randomize()
	
	$SFXTimer.start(randf_range(0.1, 0.2))


func _on_sfx_timer_timeout() -> void:
	$hit_arrow2.play(0.50)
