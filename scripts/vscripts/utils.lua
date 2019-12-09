if Utils == nil then
    print('[Utils] creating Utils')
    Utils = {}
end

-- 创建单位并设置所有技能等级为1
function Utils:create_unit_and_set_ability(sUnitName, vPosition, bClearSpace,
                                           hNPCOwner, hUnitOwner, nTeamNumber)
    local unit = CreateUnitByName(sUnitName, vPosition, bClearSpace, hNPCOwner,
                                  hUnitOwner, nTeamNumber)
    -- 设置技能等级
    local count = unit:GetAbilityCount()
    for i = 0, count - 1 do
        ability = unit:GetAbilityByIndex(i)
        if ability then ability:SetLevel(1) end
    end
    return unit
end

-- 无需知道拥有者的创建单位
function Utils:create_unit_simple(sUnitName, vPosition, bClearSpace, nTeamNumber)
    return Utils:create_unit_and_set_ability(sUnitName, vPosition, bClearSpace,
                                             nil, nil, nTeamNumber)
end
