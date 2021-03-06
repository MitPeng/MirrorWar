function use_fog(keys)
    local caster = keys.caster
    local fog_ability = caster:FindAbilityByName("fog")
    local ability = keys.ability
    local count = ability:GetLevelSpecialValueFor("count",
                                                  ability:GetLevel() - 1)
    for i = 1, count do
        local vec = caster:GetOrigin() +
                        RandomVector(RandomFloat(
                                         fog_ability:GetSpecialValueFor(
                                             "min_range"),
                                         fog_ability:GetSpecialValueFor(
                                             "max_range")))
        caster:CastAbilityOnPosition(vec, fog_ability, -1)
    end
end
