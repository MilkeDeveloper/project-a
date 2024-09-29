using Godot;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Runtime.Serialization;
using System.Security.Cryptography.X509Certificates;

public partial class SkillManager : Node
{
    public bool can_skill = true;
    public bool clicked = true;
    public bool key_released = false;
    [Export] private GrimoireData[] acquired_grimoires; // Grimoires adiquiridos
    private Dictionary<string, SkillData> acquired_skills = new Dictionary<string, SkillData>(); // Skills adiquiridas

    public override void _Ready() {
        // Percorre o array de grimoires e adiciona as skills
        foreach ( GrimoireData grimoire in acquired_grimoires ) {
            if (grimoire.grimoire_skill != null) {
                acquired_skills[grimoire.grimoire_skill.skill_name] = grimoire.grimoire_skill;
            }
        }  
        // Conecta a função _on_clicked_aim_skill ao sinal global
        var global = (Node)GetNode("/root/GLobals");
        global.Connect("on_click", new Callable(this, "_on_clicked_aim_skill"));
        global.Connect("key_skill_released", new Callable(this, "_on_key_skill_released"));
    }

    public override void _Process(double delta) {
        foreach (SkillData skill_data in acquired_skills.Values) {
            if (skill_data.cooldown_left > 0) {
                skill_data.cooldown_left -= (float)delta;
                if (skill_data.cooldown_left < 0) {
                    skill_data.cooldown_left = 0; // Garante que o cooldown não seja negativo
                    GD.Print("A skill está pronta para o uso novamente");
                }
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
        // Verifica se a skill existe
        if (acquired_skills.ContainsKey(skill_name)) {
            SkillData skill_data = acquired_skills[skill_name];
            if (skill_data != null) {
                // Verificca se a skill está em cooldown antes de poder usa-la
                if (skill_data.cooldown_left > 0) {
                    GD.Print("Skill está em cooldown por: " + skill_data.cooldown_left + " segundos.");
                    return;
                }
                // Instancia a skill
                Node skill = skill_data.skill_effect.Instantiate();
                GetParent().AddChild(skill);

                // Reseta e inicia o tempo de cooldown da skill baseado se a skill requer o click do botão do mouse para iniciar
                if (skill_data.is_aim_skill != true && skill_data.is_charging_skill != true) {
                    // Chama a função da skill para usá-la
                    skill.Call("use_skill", player, skill_data.damage, skill_data.cooldown, anim_component, target);
                    skill_data.cooldown_left = skill_data.cooldown;
                }
                 
                // Verifica se a skill está em cooldown e se o botão foi clicado
                else if (skill_data.is_aim_skill == true && clicked == true && skill_data.cooldown_left <= 0) {
                        // Chama a função da skill para usá-la
                        skill.Call("use_skill", player, skill_data.damage, skill_data.cooldown, anim_component, target);
                        skill_data.cooldown_left = skill_data.cooldown; // Reseta o tempo de cooldown
                        clicked = false;
                        
                }
                
                else if (skill_data.is_charging_skill == true && skill_data.cooldown_left <= 0) {
                        // Chama a função da skill para usá-la
                        skill.Call("use_skill", player, skill_data.damage, skill_data.cooldown, anim_component, target);
                        key_released = false;
                        GD.Print("Skill-initialized");
                }
            }
        }
    }
    public void _on_clicked_aim_skill() {
        GD.Print("Clicked");
        clicked = true; // Verifica se o botão foi clicado
    }

    public void _on_key_skill_released(string _skill_name) {
        GD.Print("Released");
        key_released = true; // Verifica se o botão foi solto
        reset_charge_skill(_skill_name);

    }

    // Função para iniciar o tempo de cooldown da skill quando o botão é solto
    public void reset_charge_skill(string _skill_name) {
        // Verifica se a skill existe
        if (acquired_skills.ContainsKey(_skill_name)) {
            SkillData skill_data = acquired_skills[_skill_name];
            if (skill_data != null) {
                // Verifica se a skill é uma skill de carregável
                if (skill_data.is_charging_skill == true) {
                    if (key_released == true) {
                        GD.Print("Skill Charged");
                        skill_data.cooldown_left = skill_data.cooldown; // Reseta o tempo de cooldown
            
                    }
                }
            }            
        }     
    }
}
