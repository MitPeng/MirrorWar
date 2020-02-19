function create_boss(keys)
    -- 随机刷boss
    local vec = Entities:FindByName(nil, "corner_" .. RandomInt(1, 7))
                    :GetOrigin()
    local boss = Utils:create_unit_simple(
                     _G.load_boss["boss_" ..
                         RandomInt(1, tonumber(_G.load_boss["boss_count"]))],
                     vec, true, DOTA_TEAM_CUSTOM_1)
    if keys.ability.boss_lvl ~= nil then
        keys.ability.boss_lvl = keys.ability.boss_lvl + 5
        -- boss最高24级
        if keys.ability.boss_lvl >= 23 then keys.ability.boss_lvl = 23 end
        boss:CreatureLevelUp(keys.ability.boss_lvl)
    else
        keys.ability.boss_lvl = -1
    end
    local level = boss:GetLevel()
    for i = 0, boss:GetAbilityCount() - 1 do
        abi = boss:GetAbilityByIndex(i)
        if abi and abi:GetMaxLevel() == 4 then
            abi:SetLevel(math.ceil(level / 8))
        end
    end
end
