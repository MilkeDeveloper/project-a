using Godot;
using System;

public partial class DmgPopup : Marker2D
{
	[Export]
	private AnimationPlayer anim;
	[Export] 
	private Label damage_text;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public void start_popup(int dmg, string pop_direction, Node2D attacker, Node2D target) {
		damage_text.Text = dmg.ToString();
		
		if (attacker.GlobalPosition.X > target.GlobalPosition.X) {
			anim.Play(pop_direction + "_left");
		}
		else {
			anim.Play(pop_direction + "_right");
		}
	}

	public void start_popup2(int dmg, string pop_direction, Node2D attacker, Node2D target) {
		damage_text.Text = dmg.ToString();
		
		anim.Play(pop_direction);
	}
}
