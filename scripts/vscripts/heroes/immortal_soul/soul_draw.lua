function projectile_hit(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local int_mul = ability:GetSpecialValueFor("intellect_multiple")
    local damage = ability:GetLevelSpecialValueFor("damage",
                                                   ability:GetLevel() - 1) +
                       caster:GetIntellect() * int_mul
    local damage_table = {
        victim = target,
        attacker = caster,
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL
    }
    ApplyDamage(damage_table)
    caster:Heal(damage / 10, caster)
end
