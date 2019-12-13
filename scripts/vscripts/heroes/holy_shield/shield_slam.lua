function damage(keys)
    local caster = keys.caster
    local target = keys.target
    caster:PerformAttack(target, true, true, true, true, true, false, true)
end
