function get_effect(keys)
    local caster = keys.caster
    local point = keys.target_points[1]
    local ability = keys.ability
    local radius = ability:GetSpecialValueFor("radius")
    local particleName = "particles/units/heroes/hero_dazzle/dazzle_weave.vpcf"
    local particle = ParticleManager:CreateParticle(particleName,
                                                    PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(particle, 0, point)
    ParticleManager:SetParticleControl(particle, 1, Vector(radius, 0, 0))
    ParticleManager:SetParticleControl(particle, 60, Vector(255, 69, 0))
    ParticleManager:SetParticleControl(particle, 61, Vector(1, 0, 0))
    caster:StopSound("Hero_MonkeyKing.FurArmy.Channel")
end
