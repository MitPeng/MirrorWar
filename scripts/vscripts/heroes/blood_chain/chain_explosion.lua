function fire_effect(keys)
    local caster = keys.caster
    local radius = keys.ability:GetSpecialValueFor("radius")
    local iParticleID = ParticleManager:CreateParticle(
                            "particles/econ/items/slark/slark_head_immortal/slark_immortal_dark_pact_pulses.vpcf",
                            PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(iParticleID, 1, caster,
                                          PATTACH_ABSORIGIN_FOLLOW, nil,
                                          caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(iParticleID, 2,
                                       Vector(radius, radius, radius))
    ParticleManager:ReleaseParticleIndex(iParticleID)
end

function damage_target(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1
    local base_damage = ability:GetLevelSpecialValueFor("base_damage",
                                                        ability_level)
    local target_damage_percent = ability:GetLevelSpecialValueFor(
                                      "target_damage_percent", ability_level) /
                                      100
    ApplyDamage(damage_table)
    local damage_table = {
        victim = target,
        attacker = caster,
        damage = base_damage,
        damage_type = DAMAGE_TYPE_MAGICAL
    }
    ApplyDamage(damage_table)
    local target_percent_damage = target:GetMaxHealth() * target_damage_percent
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
    local target = keys.target
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
