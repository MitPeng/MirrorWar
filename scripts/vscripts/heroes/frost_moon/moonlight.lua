-- 触发月光伤害
function moonlight_damage(keys)
    local caster = keys.caster
    local ability = keys.ability
    local target = keys.target
    local ability_level = ability:GetLevel() - 1
    local chance = ability:GetSpecialValueFor("chance")
    local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
    local random = RandomInt(1, 100)
    if random <= chance then
        target:RemoveModifierByName("modifier_moonlight_apply")
        ability:ApplyDataDrivenModifier(caster, target,
                                        "modifier_moonlight_apply", {})
        local damage_table = {
            victim = target,
            attacker = caster,
            damage = damage,
            damage_type = DAMAGE_TYPE_PURE
        }
        ApplyDamage(damage_table)
    end
end
