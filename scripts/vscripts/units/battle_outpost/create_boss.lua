function create_boss(keys)
    local vec = Entities:FindByName(nil, "corner_" .. RandomInt(1, 7))
                    :GetOrigin()
    local boss = Utils:create_unit_simple("boss_1", vec, true,
                                          DOTA_TEAM_CUSTOM_1)
    if keys.ability.boss_lvl ~= nil then
        boss:CreatureLevelUp(keys.ability.boss_lvl)
        keys.ability.boss_lvl = keys.ability.boss_lvl + 5
        -- boss最高20级
        if keys.ability.boss_lvl >= 19 then keys.ability.boss_lvl = 19 end
    else
        keys.ability.boss_lvl = -1
    end
end
