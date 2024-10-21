extends GridContainer

@export var GrimoireInv: Array[Resource]
@export var panel_name: Label

var InvSlot

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
	panel_name.text = "Grimoires & Cards"
	InvSlot = GrimoireInv[index]
	
	var _slot = get_child(index)
	
	if InvSlot != null and InvSlot is SkillCardData:
		_slot.get_child(0).texture = InvSlot.card_icon
	elif InvSlot != null and InvSlot is SpecGrimoireData: 
		_slot.get_child(0).texture = InvSlot.grimoire_icon
	else:
		_slot.get_child(0).texture = null
