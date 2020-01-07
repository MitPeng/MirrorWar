function elven_wrath(keys)
    local caster = keys.caster
    local point = caster:GetAbsOrigin()
    local ability = keys.ability
    local targetTeam = ability:GetAbilityTargetTeam()
    local targetType = ability:GetAbilityTargetType()
    local targetFlag = ability:GetAbilityTargetFlags()
    local damageType = ability:GetAbilityDamageType()
    local radius = ability:GetSpecialValueFor("radius")
    local base_damage = ability:GetLevelSpecialValueFor("base_damage",
                                                        ability:GetLevel() - 1)
    local tree_damage = ability:GetLevelSpecialValueFor("tree_damage",
                                                        ability:GetLevel() - 1)
    local trees = GridNav:GetAllTreesAroundPoint(point, radius, false)
    local damage = #trees * tree_damage + base_damage
    GridNav:DestroyTreesAroundPoint(point, radius, false)
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
