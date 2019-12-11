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
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1
    local cd = ability:GetCooldown(ability_level)
    ability:StartCooldown(cd)
end

-- 自动获取经验、金钱,0.3秒一次
function get_exp_and_gold(keys)
    local caster = keys.caster
    local level = caster:GetLevel()
    local xp = 3.0 + level / 1.5
    caster:AddExperience(xp, 0, false, false)
    local gold = caster:GetGold() + 5
    caster:SetGold(gold, false)
end
