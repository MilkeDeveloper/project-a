using Godot;
using System;
using System.Linq;

public partial class GrimoireData : Resource
{
    [Export]  public string grimoire_name;
    [Export]  private string grimoire_description;
    [Export] private Texture grimoire_icon;
    [Export] public SkillData grimoire_skill;
    [Export]  public string[] required_weapon_type;
    [Export]  public bool is_shield = false;

    // Função para retornar se a arma primária é compatível
    public bool IsPrimaryWeaponCompatible(WeaponData primary_weapon) {
        return required_weapon_type.Contains<string>(primary_weapon.weapon_type);
    }
    // Função para retornar se a arma secudária é compatível
    public bool IsSecondaryWeaponCompatible(WeaponData secondary_weapon) {
        return required_weapon_type.Contains<string>(secondary_weapon.weapon_type);
    }
    // Função para retornar se a arma é um escudo ou não
    public bool RequiresShield(WeaponData secondary_weapon) {
        return is_shield = secondary_weapon.is_shield;
    }
}
