function damage( keys )
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
        damage_type = DAMAGE_TYPE_MAGICAL
    }
    ApplyDamage(damage_table)
end