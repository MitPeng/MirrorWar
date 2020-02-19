function fire_effect(keys)
    local target = keys.target
    local particleName =
        "particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf"
    local particle = ParticleManager:CreateParticle(particleName,
                                                    PATTACH_WORLDORIGIN, target)
    local vec = target:GetAbsOrigin()
    ParticleManager:SetParticleControl(particle, 0, Vector(vec.x, vec.y, 1000))
    ParticleManager:SetParticleControl(particle, 1, vec)
end
