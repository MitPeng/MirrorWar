function set_damage(keys)
    local caster = keys.caster
    local ability = keys.ability
    if caster:HasModifier("modifier_soul_harvest_count") then
        local count = caster:GetModifierStackCount(
                          "modifier_soul_harvest_count", caster) +
                          ability:GetLevelSpecialValueFor("increase_damage",
                                                          ability:GetLevel() - 1)
        caster:SetModifierStackCount("modifier_soul_harvest_count", caster,
                                     count)
    else
        local count = ability:GetLevelSpecialValueFor("increase_damage",
                                                      ability:GetLevel() - 1)
        ability:ApplyDataDrivenModifier(caster, caster,
                                        "modifier_soul_harvest_count", {})
        caster:SetModifierStackCount("modifier_soul_harvest_count", caster,
                                     count)
    end
end
