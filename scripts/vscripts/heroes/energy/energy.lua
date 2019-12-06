-- 设置能量点数
function set_energy_count(keys)
    local caster = keys.caster
    local ability = keys.ability
    local modifier = "modifier_set_energy_count"
    if caster.energy then
        caster:SetModifierStackCount(modifier, caster, math.floor(caster.energy))
    end
end

-- 大招释放之前判断是否有100能量
function is_energy_enough(keys)
    local caster = keys.caster
    local ability = keys.ability
    local modifier = "modifier_set_energy_count"
    if caster.energy < 100 then
        caster:Stop()
        ability:StartCooldown(1)
    end
end

-- 大招释放结束能量清零
function spend_energy(keys)
    local caster = keys.caster
    caster.energy = 0
end

