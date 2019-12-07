--[[
function exp_up(keys)
    local target_entities = keys.target_entities
    for _, target in ipairs(target_entities) do
        local level = target:GetLevel()
        local xp = 10.0 + level * 2
        target:AddExperience(xp, 0, false, false)
    end
end
--]] 