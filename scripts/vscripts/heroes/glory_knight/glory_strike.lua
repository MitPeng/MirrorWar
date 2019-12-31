function damage(keys)
    local target = keys.target
    local caster = keys.caster
    local ability = keys.ability
    local damage = caster:GetAverageTrueAttackDamage(caster) *
                       ability:GetLevelSpecialValueFor("attack_percent",
                                                       ability:GetLevel() - 1) /
                       100
    local damage_table = {
        victim = target,
        attacker = caster,
        damage = damage,
        damage_type = DAMAGE_TYPE_PHYSICAL
    }
    ApplyDamage(damage_table)
end

function get_effect(keys)
    local caster = keys.caster
    local point = keys.target_points[1]
    local ability = keys.ability
    local radius = ability:GetSpecialValueFor("radius")
    local effect_name =
        "particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_purification_ti6_immortal.vpcf"
    local particle = ParticleManager:CreateParticle(effect_name,
                                                    PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(particle, 0, point)
    ParticleManager:SetParticleControl(particle, 1,
                                       Vector(radius, radius, radius))

end
