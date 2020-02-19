function apply_attack_speed(keys)
    local caster = keys.caster
    local target_entities = keys.target_entities
    if #target_entities > 0 then
        local ability = keys.ability
        local count = #target_entities *
                          ability:GetLevelSpecialValueFor("count_per_hero",
                                                          ability:GetLevel() - 1)
        if caster:HasModifier("modifier_furious_count") then
            caster:RemoveModifierByName("modifier_furious_count")
        end
        if count ~= 0 then
            ability:ApplyDataDrivenModifier(caster, caster,
                                            "modifier_furious_count",
                                            {duration = -1})
            caster:SetModifierStackCount("modifier_furious_count", caster, count)
        end
    end
end
