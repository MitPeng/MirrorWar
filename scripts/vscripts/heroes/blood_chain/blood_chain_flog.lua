function init_value(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local caster_location = caster:GetAbsOrigin()
    local target_location = target:GetAbsOrigin()
    target.ability_damage = ability:GetLevelSpecialValueFor("damage",
                                                            ability:GetLevel() -
                                                                1) / 30
    target.ability_distance = (target_location - caster_location):Length2D()
    target.ability_duration = ability:GetLevelSpecialValueFor("duration",
                                                              ability:GetLevel() -
                                                                  1)
    target.ability_direction = (caster_location - target_location):Normalized()
    target.ability_speed = (target.ability_distance - 150) /
                               (target.ability_duration * 30)
    target.ability_save_distance = 0
end

function target_motion(keys)
    local caster = keys.caster
    local target = keys.target
    if target.ability_distance < 150 then
        return
    else
        if target.ability_save_distance + 150 < target.ability_distance then
            local target_origin = target:GetAbsOrigin() +
                                      target.ability_direction *
                                      target.ability_speed
            target:SetAbsOrigin(target_origin)
            target.ability_save_distance =
                target.ability_save_distance + target.ability_speed
        else
            return
        end
    end

end

-- function aoe_motion(keys)
--     local caster = keys.caster
--     local target = keys.target
--     local ability = keys.ability
--     local ability_target_location = ability.ability_target:GetAbsOrigin()
--     local target_location = target:GetAbsOrigin()
--     local direction = (ability_target_location - target_location):Normalized()
--     local distance = (ability_target_location - target_location):Length2D()
--     local speed = distance / 50
--     -- 距离大于0则继续牵引
--     if distance > 50 then
--         local target_origin = target_location + direction * speed
--         target:SetAbsOrigin(target_origin)
--     else
--         return
--     end
-- end
