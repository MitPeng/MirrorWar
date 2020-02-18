function apply_attack_speed(keys)
    local caster = keys.caster
    local target_entities = keys.target_entities
    local ability = keys.ability
    local count = #target_entities *
                      (ability:GetSpecialValueFor("base_count_per_hero") +
                          ability:GetSpecialValueFor("lvl_count_per_hero") *
                          caster:GetLevel())
    caster:RemoveModifierByName("modifier_furious_count")
    if count ~= 0 then
        ability:ApplyDataDrivenModifier(caster, caster,
                                        "modifier_furious_count",
                                        {duration = -1})
        caster:SetModifierStackCount("modifier_furious_count", caster, count)
    end
end
