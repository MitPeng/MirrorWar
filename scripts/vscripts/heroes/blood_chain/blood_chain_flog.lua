function init_value(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local caster_location = caster:GetAbsOrigin()
    local target_location = target:GetAbsOrigin()
    ability.ability_distance = (target_location - caster_location):Length2D()
    ability.ability_duration = ability:GetLevelSpecialValueFor("duration",
                                                               ability:GetLevel() -
                                                                   1)
    ability.ability_direction = (caster_location - target_location):Normalized()
    ability.ability_speed = (ability.ability_distance - 150) /
                                (ability.ability_duration * 30)
    ability.ability_save_distance = 0
end

function target_motion(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    if ability.ability_distance < 150 then
        -- target:InterruptMotionControllers(false)
        return
    else
        if ability.ability_save_distance + 150 < ability.ability_distance then
            local target_origin = target:GetAbsOrigin() +
                                      ability.ability_direction *
                                      ability.ability_speed
            target:SetAbsOrigin(target_origin)
            -- FindClearSpaceForUnit(target, target_origin, false)
            ability.ability_save_distance =
                ability.ability_save_distance + ability.ability_speed
        else
            -- target:InterruptMotionControllers(false)
            return
        end
    end

end

function aoe_motion(keys)
    -- body
end
