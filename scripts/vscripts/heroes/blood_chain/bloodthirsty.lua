-- 使用技能后加buff
function apply_modifier(keys)
    local caster = keys.caster
    local ability = keys.ability
    -- 获取当前释放的技能
    local event_ability = keys.event_ability
    local isItem = event_ability:IsItem()
    if not isItem then
        local trigger_hp = ability:GetLevelSpecialValueFor("trigger_hp",
                                                           ability:GetLevel() -
                                                               1)
        if caster:GetHealthPercent() <= trigger_hp then
            caster:RemoveModifierByName("modifier_bloodthirsty_apply")
            caster:RemoveModifierByName("modifier_bloodthirsty_apply_2")
            ability:ApplyDataDrivenModifier(caster, caster,
                                            "modifier_bloodthirsty_apply_2", {})
        else
            caster:RemoveModifierByName("modifier_bloodthirsty_apply")
            caster:RemoveModifierByName("modifier_bloodthirsty_apply_2")
            ability:ApplyDataDrivenModifier(caster, caster,
                                            "modifier_bloodthirsty_apply", {})
        end

    end
end
