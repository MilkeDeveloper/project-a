using Godot;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Security.Cryptography.X509Certificates;

public partial class SkillManager : Node
{
    public bool can_skill = true;
    [Export] private GrimoireData[] acquired_grimoires; // Grimoires adiquiridos
    private Dictionary<string, SkillData> acquired_skills = new Dictionary<string, SkillData>(); // Skills adiquiridas

    public override void _Ready() {
        // Percorre o array de grimoires e adiciona as skills
        foreach ( GrimoireData grimoire in acquired_grimoires ) {
            if (grimoire.grimoire_skill != null) {
                acquired_skills[grimoire.grimoire_skill.skill_name] = grimoire.grimoire_skill;
            }
        }  
    }
    // Adiciona um novo grimoire
    public void Add_grimoire( GrimoireData grimoire ) {
        if (grimoire.grimoire_skill != null) {
            acquired_skills[grimoire.grimoire_skill.skill_name] = grimoire.grimoire_skill;
            acquired_grimoires.Append( grimoire );
        }
    }
    // Remove um grimoire
    public void Remove_grimoire( GrimoireData grimoire ) {
        if (acquired_skills.ContainsKey(grimoire.grimoire_skill.skill_name)) {
            acquired_skills.Remove( grimoire.grimoire_skill.skill_name );
        }
        // Converte o Array de grimoires para uma lista e remove o grimoire
        List<GrimoireData> new_acquired_grimoires = new List<GrimoireData>(acquired_grimoires);
        new_acquired_grimoires.Remove( grimoire );
        acquired_grimoires = new_acquired_grimoires.ToArray();
    }
    // Verifica se o player pode usar a skill com o equipamento atual
    public bool can_use_skill( string skill_name, WeaponData primary_weapon, WeaponData secondary_weapon ) {
        foreach ( GrimoireData grimoire in acquired_grimoires ) {
            if (grimoire.grimoire_skill.skill_name == skill_name) {
                // Verifica se o personagem está usando o tipo de equipamento correto
                if(!grimoire.IsPrimaryWeaponCompatible(primary_weapon) || !grimoire.IsSecondaryWeaponCompatible(secondary_weapon)) {
                    return false; // Não está usando o tipo de arma correto que a skill requer
                }
                // Verifica se o a skill requer que e o personagem esteja equipando um shield, e se a arma secundária que ele está equipando é um shield
                if (!grimoire.RequiresShield(secondary_weapon)) {
                    return false; // A skill requer que o personagem esteja equipando um escudo, mas ele não está equipado
                }
                return true; // O personagem pode usar a skill
            }
        }
        return false;
    }
    // Função para ativar a habilidade o seus efeitos
    public void activate_skill(string skill_name, CharacterBody2D player, Node2D anim_component, Node target = null) {
        if (acquired_skills.ContainsKey(skill_name)) {
            SkillData skill_data = acquired_skills[skill_name];
            if (skill_data != null) {
                // Instancia a skill
                Node skill = skill_data.skill_effect.Instantiate();
                GetParent().AddChild(skill);

                
                float cooldown_left = (float)skill.Call("skill_time_left");
                if (can_skill == false) {
                    GD.Print("Skill está em cooldown por: " + cooldown_left + " segundos.");
                    return;
                }
                // Chama a função da skill para usá-la
                skill.Call("use_skill", player, skill_data.cooldown, anim_component, target);
            }
        }
    }
}
