require("timers")

function falling_star_create_unit(keys)
    local caster = keys.caster
    local point = keys.target_points[1]
    local ability = keys.ability
    local duration = ability:GetSpecialValueFor("duration")
    Timers:CreateTimer(0, function()
        -- create void unit to do damage and apply debuff modifier
        local void_unit = CreateUnitByName("npc_dummy_unit", point, false,
                                           caster, caster,
                                           caster:GetTeamNumber())
        ability:ApplyDataDrivenModifier(caster, void_unit,
                                        "modifier_falling_star_unit", {})
        Timers:CreateTimer(duration, function()
            void_unit:RemoveModifierByName("modifier_falling_star_unit")
            void_unit:StopSound("hero_Crystal.freezingField.wind")
            void_unit:ForceKill(true)
            return nil
        end)
        return nil
    end)
end

function falling_star_damage(keys)
    local caster = keys.caster
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1
    local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
    local target_entities = keys.target_entities
    for i, target in ipairs(target_entities) do
        caster:PerformAttack(target, false, true, true, true, true, true, true)
        local damage_table = {
            victim = target,
            attacker = caster,
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL
        }
        ApplyDamage(damage_table)
    end
end
