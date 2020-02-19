function use_rolling_stone(keys)
    local caster = keys.caster
    local rolling_stone_ability = caster:FindAbilityByName("rolling_stone")
    local ability = keys.ability
    local count = ability:GetLevelSpecialValueFor("count",
                                                  ability:GetLevel() - 1)
    for i = 1, count do
        local vec = caster:GetOrigin() +
                        RandomVector(RandomFloat(
                                         rolling_stone_ability:GetSpecialValueFor(
                                             "min_range"),
                                         rolling_stone_ability:GetSpecialValueFor(
                                             "max_range")))
        vec = GetGroundPosition(vec, nil)
        caster:CastAbilityOnPosition(vec, rolling_stone_ability, -1)
    end
end
