function save_caster(keys)
    local target = keys.target
    local caster = keys.caster
    target.soul_conn_caster = nil
    target.soul_conn_ability = nil
    target.soul_conn_caster = caster
    target.soul_conn_ability = keys.ability
end
function clear_caster(keys)
    local target = keys.target
    target.soul_conn_caster = nil
    target.soul_conn_ability = nil
    keys.caster:StopSound("Hero_Wisp.Tether")
end
function break_conn(keys)
    local target = keys.target
    local caster = keys.caster
    if caster:IsAlive() and target:IsAlive() then
        local ability = keys.ability
        local target_vec = target:GetOrigin()
        local caster_vec = caster:GetOrigin()
        local distance = ((target_vec.x - caster_vec.x) ^ 2 +
                             (target_vec.y - caster_vec.y) ^ 2) ^ 0.5
        local break_distance = ability:GetLevelSpecialValueFor("break_distance",
                                                               ability:GetLevel() -
                                                                   1)
        if distance - break_distance > 0 then
            caster:RemoveModifierByName("modifier_soul_connection_caster")
            target:RemoveModifierByName("modifier_soul_connection_target")
        end
    else
        caster:RemoveModifierByName("modifier_soul_connection_caster")
        target:RemoveModifierByName("modifier_soul_connection_target")
    end
end
