-- 每分钟升1级
function lvlup(keys)
    local boss = keys.caster
    -- 最高25级
    if boss:GetLevel() < 25 then
        local health_percent = boss:GetHealthPercent() / 100
        boss:CreatureLevelUp(1)
        boss:SetHealth(boss:GetMaxHealth() * health_percent)
    end
end

-- Boss被击杀给奖励
function death(keys)
    local boss = keys.caster
    local hero = keys.attacker
    local ability = keys.ability

    local boss_name = boss:GetUnitName()
    local buff_name = _G.load_boss[boss_name .. "_buff"]
    local buff_count = tonumber(_G.load_boss[boss_name .. "_buff_count"])
    -- 判断是否为队友
    for i = 0, GameRules.player_count - 1 do
        local bonus_hero = GameRules.player_data[i].hero
        if bonus_hero:GetTeam() == hero:GetTeam() then
            -- 击杀特效
            local particle = ParticleManager:CreateParticle(
                                 "particles/" .. boss_name .. "_buff.vpcf",
                                 PATTACH_ABSORIGIN_FOLLOW, bonus_hero)
            local point = bonus_hero:GetOrigin()
            ParticleManager:SetParticleControl(particle, 0, point)
            -- 击杀音效
            hero:EmitSound("n_creep_dragonspawnOverseer.Death")
            -- 击杀奖励buff
            if bonus_hero:HasModifier(buff_name) then
                local new_buff_count = bonus_hero:GetModifierStackCount(
                                           buff_name, bonus_hero) + buff_count
                bonus_hero:SetModifierStackCount(buff_name, bonus_hero,
                                                 new_buff_count)
            else
                -- 若英雄死亡则复活后加buff
                if bonus_hero:IsAlive() then
                    ability:ApplyDataDrivenModifier(bonus_hero, bonus_hero,
                                                    buff_name, {})
                    bonus_hero:SetModifierStackCount(buff_name, bonus_hero,
                                                     buff_count)
                else
                    -- 保存一下信息，重生后再加buff
                    bonus_hero.boss_bonus_buff_name = buff_name
                    bonus_hero.boss_bonus_buff_count = buff_count
                    bonus_hero.boss_bonus_ability = ability
                end
            end
        end
    end
    -- 加积分
    local boss_score = _G.load_kv["base_boss_score"] + boss:GetLevel() *
                           _G.load_kv["lvl_boss_score"]
    local owner = hero:GetOwner()
    if hero:IsHero() then
        hero.boss_score = hero.boss_score + boss_score
    elseif owner and owner:IsHero() then
        owner.boss_score = owner.boss_score + boss_score
    else
        if hero:GetTeam() == DOTA_TEAM_GOODGUYS then
            GameRules.good_boss_score = GameRules.good_boss_score + boss_score
        end
        if hero:GetTeam() == DOTA_TEAM_BADGUYS then
            GameRules.bad_boss_score = GameRules.bad_boss_score + boss_score
        end
    end
end
