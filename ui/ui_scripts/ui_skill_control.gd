extends Control

var gui_window
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gui_window = Rect2(self.position, self.size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse_left") and gui_window.has_point(get_global_mouse_position()):
		$GPUParticles2D.position = get_global_mouse_position()
		$anim.play("click")
