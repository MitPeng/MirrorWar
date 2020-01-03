function init_data(keys)
    local caster = keys.caster
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1
    ability.damage_radius = ability:GetLevelSpecialValueFor("damage_radius",
                                                            ability_level)
    ability.min_distance = ability:GetLevelSpecialValueFor("min_distance",
                                                           ability_level)
    ability.max_distance = ability:GetLevelSpecialValueFor("max_distance",
                                                           ability_level)
    ability.attack_percent = ability:GetLevelSpecialValueFor("attack_percent",
                                                             ability_level) /
                                 100
    ability.count = 0
end

function shadow_lord(keys)
    local caster = keys.caster
    local ability = keys.ability
    local casterLocation = caster:GetAbsOrigin()
    local directionConstraint = ability.count
    local particleName =
        "particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf"
    local targetTeam = ability:GetAbilityTargetTeam()
    local targetType = ability:GetAbilityTargetType()
    local targetFlag = ability:GetAbilityTargetFlags()
    local damageType = ability:GetAbilityDamageType()
    local damage = ability.attack_percent *
                       caster:GetAverageTrueAttackDamage(caster)
    -- Get random point
    local castDistance = RandomInt(ability.min_distance, ability.max_distance)
    local angle = RandomInt(0, 90)
    local dy = castDistance * math.sin(angle)
    local dx = castDistance * math.cos(angle)
    local attackPoint = Vector(0, 0, 0)

    if directionConstraint % 4 == 0 then -- NW
        attackPoint = Vector(casterLocation.x - dx, casterLocation.y + dy,
                             casterLocation.z)
    elseif directionConstraint % 4 == 1 then -- NE
        attackPoint = Vector(casterLocation.x + dx, casterLocation.y + dy,
                             casterLocation.z)
    elseif directionConstraint % 4 == 2 then -- SE
        attackPoint = Vector(casterLocation.x + dx, casterLocation.y - dy,
                             casterLocation.z)
    elseif directionConstraint % 4 == 3 then -- SW
        attackPoint = Vector(casterLocation.x - dx, casterLocation.y - dy,
                             casterLocation.z)
    end
    ability.count = ability.count + 1
    local units = FindUnitsInRadius(caster:GetTeamNumber(), attackPoint, caster,
                                    ability.damage_radius, targetTeam,
                                    targetType, targetFlag, 0, false)
    for _, v in pairs(units) do
        local damageTable = {
            victim = v,
            attacker = caster,
            damage = damage,
            damage_type = damageType
        }
        ApplyDamage(damageTable)
    end

    -- Fire effect
    local fxIndex = ParticleManager:CreateParticle(particleName,
                                                   PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(fxIndex, 0, attackPoint)
end

function stop_sound(keys)
    local caster = keys.caster
    caster:StopSound("Hero_Nevermore.RequiemOfSoulsCast")

end

function stop_effect(keys)
    local caster = keys.caster
    StopEffect(caster,
               "particles/units/heroes/hero_nevermore/nevermore_wings.vpcf")
end
