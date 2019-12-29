function get_team_point(keys)
    local caster = keys.caster
    local target_entities = keys.target_entities
    local good = 0
    local bad = 0
    local good_hero = {}
    local bad_hero = {}
    for i, target in ipairs(target_entities) do
        local team = target:GetTeam()
        if team then
            if team == DOTA_TEAM_GOODGUYS then
                good = good + 1
                good_hero[good] = target
            elseif team == DOTA_TEAM_BADGUYS then
                bad = bad + 1
                bad_hero[bad] = target
            end
        end
    end
    if good ~= 0 and bad ~= 0 then
        -- print("good=bad")
    elseif good == 0 and bad ~= 0 then
        print("bad:" .. bad)
        local particle_name =
            "particles/world_outpost/world_outpost_dire_ambient_shockwave.vpcf"
        local particle = ParticleManager:CreateParticle(particle_name,
                                                        PATTACH_OVERHEAD_FOLLOW,
                                                        caster)
        caster:EmitSound("Outpost.Reward")
        for _, hero in ipairs(bad_hero) do
            hero.outpost_score = hero.outpost_score + 1
            local particle_name_2 =
                "particles/generic_gameplay/outpost_reward.vpcf"
            local particle_2 = ParticleManager:CreateParticle(particle_name_2,
                                                              PATTACH_ABSORIGIN_FOLLOW,
                                                              hero)
        end
    elseif good ~= 0 and bad == 0 then
        print("good:" .. good)
        local particle_name =
            "particles/world_outpost/world_outpost_radiant_ambient_shockwave.vpcf"
        local particle = ParticleManager:CreateParticle(particle_name,
                                                        PATTACH_OVERHEAD_FOLLOW,
                                                        caster)
        caster:EmitSound("Outpost.Reward")
        for _, hero in ipairs(good_hero) do
            hero.outpost_score = hero.outpost_score + 1
            local particle_name_2 =
                "particles/generic_gameplay/outpost_reward.vpcf"
            local particle_2 = ParticleManager:CreateParticle(particle_name_2,
                                                              PATTACH_ABSORIGIN_FOLLOW,
                                                              hero)
        end
    end
end

function vision(keys)
    local loc = keys.caster:GetAbsOrigin()
    local radius = keys.ability:GetSpecialValueFor("radius")
    AddFOWViewer(DOTA_TEAM_GOODGUYS, loc, radius, 0.5, false)
    AddFOWViewer(DOTA_TEAM_BADGUYS, loc, radius, 0.5, false)
end

