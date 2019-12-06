require("timers")
function shrapnel_shoot(keys)
    local caster = keys.caster
    local point = keys.target_points[1]
    local casterLoc = caster:GetAbsOrigin()
    -- 设置施法者面向角度
    caster:SetForwardVector(((point - caster:GetOrigin()):Normalized()))
    -- 获取前方向量
    local forward_vector = caster:GetForwardVector()
    local launch_particle_name =
        "particles/units/heroes/hero_sniper/sniper_shrapnel_launch.vpcf"
    -- Create particle at caster
    local fxLaunchIndex = ParticleManager:CreateParticle(launch_particle_name,
                                                         PATTACH_CUSTOMORIGIN,
                                                         caster)
    ParticleManager:SetParticleControl(fxLaunchIndex, 0, casterLoc)
    ParticleManager:SetParticleControl(fxLaunchIndex, 1,
                                       Vector(
                                           casterLoc.x + forward_vector.x * 500,
                                           casterLoc.y + forward_vector.y * 500,
                                           1600))
end

function shrapnel_create_unit(keys)
    local caster = keys.caster
    local point = keys.target_points[1]
    local ability = keys.ability
    local duration = ability:GetSpecialValueFor("duration")
    local delay = ability:GetSpecialValueFor("delay")
    Timers:CreateTimer(delay, function()
        -- create void unit to do damage and apply debuff modifier
        local void_unit = CreateUnitByName("npc_dummy_unit", point, false,
                                           caster, caster,
                                           caster:GetTeamNumber())
        ability:ApplyDataDrivenModifier(caster, void_unit,
                                        "modifier_shrapnel_unit", {})
        Timers:CreateTimer(duration, function()
            void_unit:RemoveModifierByName("modifier_shrapnel_unit")
            void_unit:StopSound("Hero_Sniper.ShrapnelShatter")
            void_unit:ForceKill(true)
            return nil
        end)
        return nil
    end)
end
