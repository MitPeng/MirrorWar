function use_fire_trap(keys)
    local caster = keys.caster
    local fire_trap_ability = caster:FindAbilityByName("fire_trap")
    local ability = keys.ability
    local count = ability:GetLevelSpecialValueFor("count",
                                                  ability:GetLevel() - 1)
    for i = 1, count do
        local vec = caster:GetOrigin() +
                        RandomVector(RandomFloat(
                                         fire_trap_ability:GetSpecialValueFor(
                                             "min_range"),
                                         fire_trap_ability:GetSpecialValueFor(
                                             "max_range")))
        caster:CastAbilityOnPosition(vec, fire_trap_ability, -1)
    end
end
