-- 冰叶伤害
function ice_leaf_damage(keys)
    local caster = keys.caster
    local ability = keys.ability
    local target = keys.target
    local ability_level = ability:GetLevel() - 1
    local damage =
        ability:GetLevelSpecialValueFor("base_damage", ability_level) +
            caster:GetAgility() * ability:GetSpecialValueFor("agility_times")
    caster:PerformAttack(target, true, true, true, true, true, true, true)
    damage_table = {
        victim = target,
        attacker = caster,
        damage = damage,
        damage_type = DAMAGE_TYPE_PHYSICAL
    }
    ApplyDamage(damage_table)
end
