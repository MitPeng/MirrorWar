function head_shot_shoot(keys)
    local caster = keys.caster
    local point = keys.target_points[1]
    local casterLoc = caster:GetAbsOrigin()
    -- 设置施法者面向角度
    caster:SetForwardVector(((point - caster:GetOrigin()):Normalized()))
    -- 获取前方向量
    local forward_vector = caster:GetForwardVector()
    local target_point = casterLoc + forward_vector * 1500
    local launch_particle_name =
        "particles/units/heroes/hero_sniper/sniper_shrapnel_launch.vpcf"
    -- Create particle at caster
    local fxLaunchIndex = ParticleManager:CreateParticle(launch_particle_name,
                                                         PATTACH_CUSTOMORIGIN,
                                                         caster)
    ParticleManager:SetParticleControl(fxLaunchIndex, 0, Vector(casterLoc.x,
                                                                casterLoc.y,
                                                                casterLoc.z + 50))
    ParticleManager:SetParticleControl(fxLaunchIndex, 1, Vector(target_point.x,
                                                                target_point.y,
                                                                point.z + 50))
end

function head_shot_damage(keys)
    local caster = keys.caster
    local target = keys.target
    caster:PerformAttack(target, true, true, true, true, true, false, true)
end
