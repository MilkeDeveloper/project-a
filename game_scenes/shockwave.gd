extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var shock_material: ShaderMaterial
@export var cam: Camera2D

var target: Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GLobals.connect("target_found", _on_target_found)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse_left"):
	
		
		if target:
			var viewport_size := get_viewport_rect().size
			var zoomed_view := viewport_size / cam.zoom

			var cam_relative_pos = (target.global_position - cam.get_screen_center_position()) + zoomed_view / 2.0
			var ratio = zoomed_view.x / zoomed_view.y

			var x = cam_relative_pos.x / zoomed_view.x
			var y = cam_relative_pos.y / zoomed_view.y
			x = (x - 0.5) * ratio + 0.5  # Revertendo o efeito de escala no shader

			# Definindo o parâmetro do shader
			shock_material.set_shader_parameter('center', Vector2(x, y))
			print("boom")
			animation_player.play("shockwave")
			
			var camera_center = cam.get_screen_center_position()
			var adjusted_position = (global_position - camera_center) / cam.zoom
			viewport_size = get_viewport_rect().size
			
			# Normalizar para o intervalo [0, 1]
			var normalized_position = (adjusted_position + viewport_size / 2) / viewport_size
			shock_material.set_shader_parameter('center', normalized_position)

func _on_target_found(node):
	target = node
