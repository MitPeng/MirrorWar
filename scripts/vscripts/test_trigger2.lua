-- 修改器名称，修改器所在文件名，LUA驱动器类型
LinkLuaModifier("modifier_fire_trap", "modifiers/modifier_fire_trap.lua",
                LUA_MODIFIER_MOTION_NONE)

function OnStartTouch1(trigger)
    local unit = trigger.activator
    print(unit:GetUnitName(), "enter")
    unit:AddNewModifier(nil, nil, "modifier_fire_trap", {duration = -1})
end

function OnEndTouch1(trigger)
    local unit = trigger.activator
    print(unit:GetUnitName(), "out")
    if unit:HasModifier("modifier_fire_trap") then
        unit:RemoveModifierByName("modifier_fire_trap")
    end
end
