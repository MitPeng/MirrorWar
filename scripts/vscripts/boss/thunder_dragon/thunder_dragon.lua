function use_thunder_trap(keys)
    local caster = keys.caster
    local thunder_trap_ability = caster:FindAbilityByName("thunder_trap")
    local ability = keys.ability
    local count = ability:GetLevelSpecialValueFor("count",
                                                  ability:GetLevel() - 1)
    for i = 1, count do
        local vec = caster:GetOrigin() +
                        RandomVector(RandomFloat(
                                         thunder_trap_ability:GetSpecialValueFor(
                                             "min_range"),
                                         thunder_trap_ability:GetSpecialValueFor(
                                             "max_range")))
        caster:CastAbilityOnPosition(vec, thunder_trap_ability, -1)
    end
end
