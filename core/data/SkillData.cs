using Godot;


public partial class SkillData : Resource
{
    [Export]
    public int id;
    [Export]
    public string skill_name;
    [Export]
    public string skill_description;
    [Export]
    public int mana_cost;
    [Export]
    public float cooldown;
    [Export]
    public int damage;
    [Export] 
    public bool is_aim_skill;
    [Export]
    public PackedScene skill_effect;
    public float cooldown_left;

}
