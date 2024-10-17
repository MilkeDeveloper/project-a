extends HBoxContainer


@export var spec_slot2: HBoxContainer
@export var spec_icon: TextureRect
@export var spec_level: Label

var spec : SpecData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_spec_info()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_spec_info():
	if spec_slot2.secondary_spec[0] != null:
		spec = spec_slot2.secondary_spec[0].spec
		spec_icon.texture = spec.spec_icon
		spec_level.text = "Lv. " + str(spec.spec_level)
