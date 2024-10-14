extends Node


# Signals
signal on_grimoire_clicked(item: SkillGrimoireData, index: int)
signal clear_dragged_item

# Control Vars
var on_spec_slot: bool = false
