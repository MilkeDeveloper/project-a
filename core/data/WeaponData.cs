using Godot;
using System;

public partial class WeaponData : Resource
{
	[Export] private string weapon_name;
	[Export] private string weapon_description;
	[Export] private Texture weapon_icon;
	[Export] private int damage;
	[Export] private int range;
	[Export] private float attack_speed;
	[Export] public string weapon_type;
	[Export] private bool melee = false;
	[Export] private bool ranged = false;
	[Export] public bool is_shield = false;
}
