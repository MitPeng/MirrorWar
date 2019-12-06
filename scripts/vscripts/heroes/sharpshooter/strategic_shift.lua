function strategic_shift_move(keys)
    local caster = keys.caster
    local target = keys.target
    local point = keys.target_points[1]
    local ability = keys.ability
    -- 获取施法者位置
    local caster_abs = caster:GetAbsOrigin()
    -- 设置施法者面向角度
    caster:SetForwardVector(((point - caster:GetOrigin()):Normalized()))
    -- 位移后的位置
    local target_point = point
    FindClearSpaceForUnit(caster, target_point, true)
    caster:Stop()
end
