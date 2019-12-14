function get_team_point(keys)
    local target_entities = keys.target_entities
    local good = 0
    local bad = 0
    for _, target in ipairs(target_entities) do
        local team = target:GetTeam()
        if team then
            if team == DOTA_TEAM_GOODGUYS then
                good = good + 1
            elseif team == DOTA_TEAM_BADGUYS then
                bad = bad + 1
            end
        end
    end
    if good == bad then
        -- print("good=bad")
    elseif good < bad then
        print("good<bad")
    elseif good > bad then
        print("good>bad")
    end
end
