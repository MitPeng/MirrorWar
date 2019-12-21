function stop_sounds(keys) keys.caster:StopSound("Hero_Pudge.Rot") end
function damage_target(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1
    local base_damage = ability:GetLevelSpecialValueFor("base_damage",
                                                        ability_level)
    local damage_table = {
        victim = target,
        attacker = caster,
        damage = base_damage,
        damage_type = DAMAGE_TYPE_MAGICAL
    }
    ApplyDamage(damage_table)
    local target_damage_percent = ability:GetLevelSpecialValueFor(
                                      "target_damage_percent", ability_level) /
                                      100
    local target_percent_damage = caster:GetMaxHealth() * target_damage_percent
    damage_table = {
        victim = target,
        attacker = caster,
        damage = target_percent_damage,
        damage_type = DAMAGE_TYPE_MAGICAL
    }
    ApplyDamage(damage_table)
end

function damage_self(keys)
    local caster = keys.caster
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1
    local self_damage_percent = ability:GetLevelSpecialValueFor(
                                    "self_damage_percent", ability_level) / 100
    local self_percent_damage = caster:GetHealth() * self_damage_percent
    local damage_table = {
        victim = caster,
        attacker = caster,
        damage = self_percent_damage,
        damage_type = DAMAGE_TYPE_MAGICAL
    }
    ApplyDamage(damage_table)
end
