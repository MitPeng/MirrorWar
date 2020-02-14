function create_boss(keys)
    local vec = Entities:FindByName(nil, "corner_" .. RandomInt(1, 7))
                    :GetOrigin()
    local boss = Utils:create_unit_simple("boss_1", vec, true,
                                          DOTA_TEAM_CUSTOM_1)
end
