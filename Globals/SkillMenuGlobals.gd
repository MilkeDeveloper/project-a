extends Node


# Signals
signal on_grimoire_clicked(item: SkillCardData, index: int)
signal on_grimoire_clicked2(item: SkillCardData, index: int)
signal clear_dragged_item

signal dragg_from_skill_menu(skill: GDSkillData)

# Control Vars
var on_spec_slot: bool = false
var specs_visible: bool = true
var can_equip_card: bool = true
var current_primary_spec_slot_selected: bool = false
var current_secondary_spec_slot_selected: bool = false
var curent_primary_skill_selected: bool = false
var curent_secondary_skill_selected: bool = false
var current_skill_tree1: String = "Staff"
var current_skill_tree2: String = "Wand"
