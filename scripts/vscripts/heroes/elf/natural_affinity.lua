function natural_affinity(keys)
    local caster = keys.caster
    local ability = keys.ability
    local level = ability:GetLevel() - 1
    local radius = ability:GetLevelSpecialValueFor("radius", level)
    local block_damage = ability:GetLevelSpecialValueFor("block_damage", level)
    local trees = GridNav:GetAllTreesAroundPoint(caster:GetAbsOrigin(), radius,
                                                 true)
    local count = #trees * block_damage
    caster:RemoveModifierByName("modifier_natural_affinity_jianshang")
    if count ~= 0 then
        ability:ApplyDataDrivenModifier(caster, caster,
                                        "modifier_natural_affinity_jianshang",
                                        {duration = -1})
        caster:SetModifierStackCount("modifier_natural_affinity_jianshang",
                                     caster, count)
    end
end
