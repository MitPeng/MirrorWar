function frost_flower_projectile(keys)
    -- 获取一系列参数
    local caster = keys.caster
    local point = keys.target_points[1]
    local ability = keys.ability
    local move_speed = ability:GetSpecialValueFor("move_speed")
    local start_radius = ability:GetSpecialValueFor("start_radius")
    local end_radius = ability:GetSpecialValueFor("end_radius")
    local distance = ability:GetSpecialValueFor("distance")
    local vision = ability:GetSpecialValueFor("vision")
    local effect_name = "particles/frost_moon_frost_flower_arrow.vpcf"
    -- 获取施法者位置
    local caster_abs = caster:GetAbsOrigin()
    -- 设置施法者面向角度
    caster:SetForwardVector(((point - caster:GetOrigin()):Normalized()))
    -- 获取前方向量
    local forward_vector = caster:GetForwardVector()
    -- 获取左边右边投射物向量left_vector及right_vector
    local right = caster:GetRightVector()
    local left_vector = (-right + forward_vector * 3):Normalized()
    local right_vector = (right + forward_vector * 3):Normalized()
    -- 创建三个投射物
    local mid_info = {
        Ability = ability,
        EffectName = effect_name,
        vSpawnOrigin = caster:GetAbsOrigin(),
        fDistance = distance,
        fStartRadius = start_radius,
        fEndRadius = end_radius,
        Source = caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        -- 到期时间
        -- fExpireTime = GameRules:GetGameTime() + 10.0,
        bDeleteOnHit = false,
        -- 向量*速度
        vVelocity = forward_vector * move_speed,
        bProvidesVision = true,
        iVisionRadius = vision,
        iVisionTeamNumber = caster:GetTeamNumber()
    }
    local left_info = {
        Ability = ability,
        EffectName = effect_name,
        vSpawnOrigin = caster:GetAbsOrigin(),
        fDistance = distance,
        fStartRadius = start_radius,
        fEndRadius = end_radius,
        Source = caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        -- 到期时间
        -- fExpireTime = GameRules:GetGameTime() + 10.0,
        bDeleteOnHit = false,
        -- 向量*速度
        vVelocity = left_vector * move_speed,
        bProvidesVision = true,
        iVisionRadius = vision,
        iVisionTeamNumber = caster:GetTeamNumber()
    }
    local right_info = {
        Ability = ability,
        EffectName = effect_name,
        vSpawnOrigin = caster:GetAbsOrigin(),
        fDistance = distance,
        fStartRadius = start_radius,
        fEndRadius = end_radius,
        Source = caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        -- 到期时间
        -- fExpireTime = GameRules:GetGameTime() + 10.0,
        bDeleteOnHit = false,
        -- 向量*速度
        vVelocity = right_vector * move_speed,
        bProvidesVision = true,
        iVisionRadius = vision,
        iVisionTeamNumber = caster:GetTeamNumber()
    }
    mid_projectile = ProjectileManager:CreateLinearProjectile(mid_info)
    left_projectile = ProjectileManager:CreateLinearProjectile(left_info)
    right_projectile = ProjectileManager:CreateLinearProjectile(right_info)
end

function frost_flower_is_stun(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local modifiers =
        target:FindAllModifiersByName("modifier_frost_flower_slow")
    if #modifiers == 3 then
        target:RemoveModifierByName("modifier_frost_flower_slow")
        ability:ApplyDataDrivenModifier(caster, target,
                                        "modifier_frost_flower_stun", {})
    end
end

function fake_attack(keys)
    local caster = keys.caster
    local target = keys.target
    caster:PerformAttack(target, false, true, true, true, true, true, true)
end
