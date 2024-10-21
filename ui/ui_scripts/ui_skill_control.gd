extends Control

var gui_window 
@export var skill_points: int = 20
@export var skill_points_label: Label

@export var skill: GDSkillData
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gui_window = Rect2(self.position, self.size)
	update_skill_points(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse_left") and gui_window.has_point(get_global_mouse_position()):
		$GPUParticles2D.position = get_local_mouse_position()
		$anim.play("click")
		
		apply_buff()
	
	if Input.is_action_just_pressed("cancel"):
		skill_points += 1
		update_skill_points(0)

func apply_buff():
	for buff in skill.buff_type:
		apply_buff_values(buff.amount, buff.mod_percentage)
		
			
			
func apply_buff_values(amount, mod_percentage):
	print(skill.skill_name + " buff_type: " +  str(amount))


func update_skill_points(used_points: int):
	skill_points = skill_points - used_points
	if skill_points <= 0:
		skill_points = 0
	skill_points_label.text = "Skill points: " + str(skill_points)
	return skill_points
