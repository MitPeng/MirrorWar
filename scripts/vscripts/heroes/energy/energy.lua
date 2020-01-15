-- 初始化能量
function init_energy(keys)
    local caster = keys.caster
    if not caster.energy then caster.energy = 0 end
end

-- 自动获取能量
function get_energy(keys)
    local caster = keys.caster
    if caster.energy < 100 then
        -- 每秒生成基础能量+等级加成能量
        caster.energy = caster.energy + _G.load_kv["base_energy_per_second"] +
                            caster:GetLevel() *
                            _G.load_kv["lvl_energy_per_second"]
        if caster.energy >= 100 then caster.energy = 100 end
    elseif caster.energy >= 100 then
        caster.energy = 100
    end
end

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
    if caster.energy < 100 then
        caster:Stop()
        ability:StartCooldown(1)
        _G.msg.bottom("#no_enough_energy", caster:GetPlayerID())
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
    local xp = _G.load_kv["base_xp"] + level * _G.load_kv["lvl_xp"]
    caster:AddExperience(xp, 0, false, false)
    local gold = caster:GetGold() + _G.load_kv["base_gold"] + level *
                     _G.load_kv["lvl_gold"]
    caster:SetGold(gold, false)
end
