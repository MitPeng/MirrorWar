function germination(keys)
    local caster = keys.caster
    local point = keys.target_points[1]
    local ability = keys.ability
    local radius = ability:GetSpecialValueFor("radius")
    local number = ability:GetLevelSpecialValueFor("number",
                                                   ability:GetLevel() - 1)
    local duration = ability:GetLevelSpecialValueFor("duration",
                                                     ability:GetLevel() - 1)
    for i = 1, number do
        local distance = RandomInt(0, radius)
        local angle = RandomInt(0, 360)
        local dy = distance * math.sin(angle)
        local dx = distance * math.cos(angle)
        local vec = Vector(point.x + dx, point.y + dy, point.z)
        CreateTempTree(vec, duration)
    end
end
