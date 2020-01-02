function save_attack_damage(keys)
    local target = keys.target
    local ability = keys.ability
    local percent = -ability:GetLevelSpecialValueFor("percent",
                                                     ability:GetLevel() - 1) /
                        100
    local attack_damage = target:GetAverageTrueAttackDamage(target) * percent
    if ability.add_attack_damage ~= nil then
        ability.add_attack_damage = ability.add_attack_damage + attack_damage
    else
        ability.add_attack_damage = attack_damage
    end
end

function set_attack_damage(keys)
    local caster = keys.caster
    local ability = keys.ability
    ability:ApplyDataDrivenModifier(caster, caster,
                                    "modifier_soul_eater_add_attack", {})
    if ability.add_attack_damage ~= nil then
        caster:SetModifierStackCount("modifier_soul_eater_add_attack", caster,
                                     math.floor(
                                         tonumber(ability.add_attack_damage)))
    else
        caster:RemoveModifierByName("modifier_soul_eater_add_attack")
    end
end

function clear_attack_damage(keys)
    local caster = keys.caster
    local ability = keys.ability
    caster:RemoveModifierByName("modifier_soul_eater_add_attack")
    ability.add_attack_damage = nil
end

function get_effect(keys)
    local caster = keys.caster
    local effect_name =
        "particles/units/heroes/hero_shadow_demon/shadow_demon_soul_catcher.vpcf"
    local radius = keys.ability:GetLevelSpecialValueFor("radius",
                                                        keys.ability:GetLevel()) +
                       100
    local particle = ParticleManager:CreateParticle(effect_name,
                                                    PATTACH_ABSORIGIN_FOLLOW,
                                                    caster)
    ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 2, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 3,
                                       Vector(radius, radius, radius))
    ParticleManager:SetParticleControl(particle, 4, caster:GetAbsOrigin())
end
