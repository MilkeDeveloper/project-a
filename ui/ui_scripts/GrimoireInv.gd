extends GridContainer

@export var GrimoireInv: Array[SkillGrimoireData]

var InvSlot: SkillGrimoireData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_grimoire_slot_inv()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_grimoire_slot_inv():
	for i in range(get_child_count()):
		update_grimoire_inv(i)

func update_grimoire_inv(index: int):
	InvSlot = GrimoireInv[index]
	
	var _slot = get_child(index)
	
	if InvSlot != null:
		_slot.get_child(0).texture = InvSlot.grimoire_icon
