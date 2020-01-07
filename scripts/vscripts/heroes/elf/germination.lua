function germination(keys)
    local caster = keys.caster
    local point = caster:GetAbsOrigin()
    local ability = keys.ability
    local targetTeam = ability:GetAbilityTargetTeam()
    local targetType = ability:GetAbilityTargetType()
    local targetFlag = ability:GetAbilityTargetFlags()
    local damageType = ability:GetAbilityDamageType()
    local radius = ability:GetSpecialValueFor("radius")
    local number = ability:GetLevelSpecialValueFor("number",
                                                   ability:GetLevel() - 1)
    local duration = ability:GetLevelSpecialValueFor("duration",
                                                     ability:GetLevel() - 1)
    local damage = ability:GetLevelSpecialValueFor("damage",
                                                   ability:GetLevel() - 1)
    for i = 1, number do
        local distance = RandomInt(100, radius)
        local angle = RandomInt(0, 360)
        local dy = distance * math.sin(angle)
        local dx = distance * math.cos(angle)
        local vec = Vector(point.x + dx, point.y + dy, point.z)
        CreateTempTree(vec, duration)
    end
    local units = FindUnitsInRadius(caster:GetTeamNumber(), point, caster,
                                    radius, targetTeam, targetType, targetFlag,
                                    0, false)
    for _, v in pairs(units) do
        local damageTable = {
            victim = v,
            attacker = caster,
            damage = damage,
            damage_type = damageType
        }
        ApplyDamage(damageTable)
    end
end
