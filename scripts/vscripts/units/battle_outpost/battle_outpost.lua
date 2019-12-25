function get_team_point(keys)
    local target_entities = keys.target_entities
    local good = 0
    local bad = 0
    for _, target in ipairs(target_entities) do
        local team = target:GetTeam()
        if team then
            if team == DOTA_TEAM_GOODGUYS then
                good = good + 1
            elseif team == DOTA_TEAM_BADGUYS then
                bad = bad + 1
            end
        end
    end
    if good ~= 0 and bad ~= 0 then
        -- print("good=bad")
    elseif good == 0 and bad ~= 0 then
        print("bad")
        local particle_name =
            "particles/world_outpost/world_outpost_dire_ambient_shockwave.vpcf"
        local particle = ParticleManager:CreateParticle(particle_name,
                                                        PATTACH_OVERHEAD_FOLLOW,
                                                        caster)
    elseif good ~= 0 and bad == 0 then
        print("good")
        local particle_name =
            "particles/world_outpost/world_outpost_radiant_ambient_shockwave.vpcf"
        local particle = ParticleManager:CreateParticle(particle_name,
                                                        PATTACH_OVERHEAD_FOLLOW,
                                                        caster)
    end
end

function vision(keys)
    local loc = keys.caster:GetAbsOrigin()
    local radius = keys.ability:GetSpecialValueFor("radius")
    AddFOWViewer(DOTA_TEAM_GOODGUYS, loc, radius, 0.5, false)
    AddFOWViewer(DOTA_TEAM_BADGUYS, loc, radius, 0.5, false)
end

