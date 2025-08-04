using Godot;

public partial class SkillBase : Node
{
	public bool on_cooldown = false;
	public new float cooldown;
	public void active_skill() {
		if (on_cooldown) {
			return;
		}
		on_cooldown = true;   
	}

}
