-- 每分钟升1级
function lvlup(keys)
    local boss = keys.caster
    local health_percent = boss:GetHealthPercent() / 100
    boss:CreatureLevelUp(1)
    boss:SetHealth(boss:GetMaxHealth() * health_percent)
end

-- Boss被击杀给积分
function death(keys)
    local boss = keys.caster
    local hero = keys.attacker
    if hero:IsHero() then
        local boss_score = _G.load_kv["base_boss_score"] + boss:GetLevel() *
                               _G.load_kv["lvl_boss_score"]
        hero.boss_score = hero.boss_score + boss_score
    end
end
