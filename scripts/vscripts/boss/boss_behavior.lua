-- 每分钟升1级
function lvlup(keys)
    local boss = keys.caster
    boss:CreatureLevelUp(1)
end

-- Boss被击杀给积分
function death(keys)
    local boss = keys.caster
    local hero = keys.attacker
    local boss_score = _G.load_kv["base_boss_score"] + boss:GetLevel() *
                           _G.load_kv["lvl_boss_score"]
    hero.boss_score = hero.boss_score + boss_score
end
