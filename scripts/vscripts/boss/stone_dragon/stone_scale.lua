function stone_scale(keys)
    local caster = keys.caster
    local target_entities = keys.target_entities
    if #target_entities > 0 then
        local ability = keys.ability
        local count = #target_entities *
                          ability:GetLevelSpecialValueFor("count_per_hero",
                                                          ability:GetLevel() - 1)
        if caster:HasModifier("modifier_stone_scale_count") then
            caster:RemoveModifierByName("modifier_stone_scale_count")
        end
        if count ~= 0 then
            ability:ApplyDataDrivenModifier(caster, caster,
                                            "modifier_stone_scale_count",
                                            {duration = -1})
            caster:SetModifierStackCount("modifier_stone_scale_count", caster,
                                         count)
        end
    end
end
