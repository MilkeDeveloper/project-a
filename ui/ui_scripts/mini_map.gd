extends SubViewport

@export var camera_mini_map: Camera2D
@export var player: CharacterBody2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if camera_mini_map != null and player != null:
		camera_mini_map.position = player.position
		
	
