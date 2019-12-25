require("timers")
require("utils")
-- Generated from template
if CEventGameMode == nil then CEventGameMode = class({}) end

function Precache(context)
    --[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
    ]]
    PrecacheResource("soundfile",
                     "soundevents/game_sounds_heroes/game_sounds_mirana.vsndevts",
                     context)
    PrecacheResource("soundfile",
                     "soundevents/game_sounds_heroes/game_sounds_wisp.vsndevts",
                     context)
    PrecacheResource("soundfile",
                     "soundevents/game_sounds_heroes/game_sounds_bristleback.vsndevts",
                     context)
    PrecacheResource("soundfile",
                     "soundevents/game_sounds_heroes/game_sounds_mars.vsndevts",
                     context)
    PrecacheResource("soundfile",
                     "soundevents/game_sounds_heroes/game_sounds_monkey_king.vsndevts",
                     context)
    PrecacheResource("soundfile",
                     "soundevents/game_sounds_heroes/game_sounds_slark.vsndevts",
                     context)
    PrecacheResource("soundfile",
                     "soundevents/game_sounds_heroes/game_sounds_pudge.vsndevts",
                     context)
    PrecacheResource("particle",
                     "particles/items3_fx/octarine_core_lifesteal.vpcf", context)

end
LinkLuaModifier("modifier_energy", "modifiers/modifier_energy.lua",
                LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_get_attacker", "modifiers/modifier_get_attacker.lua",
                LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_outpost_vision",
                "modifiers/modifier_outpost_vision.lua",
                LUA_MODIFIER_MOTION_NONE)

-- 英雄饰品
GameRules.npc_wears_custom = LoadKeyValues("scripts/npc/npc_wears_custom.txt")
-- 载入kv
GameRules.load_kv = LoadKeyValues("scripts/vscripts/kv/load_kv.txt")
---玩家数据
-- key是玩家id，value是一个table，包括各个玩家的数据
GameRules.player_data = {}
---玩家总数，无论是否在线，只要完全连入过游戏，就算一个
GameRules.player_count = 0

-- Create the game mode when we activate
-- 激活某些函数
function Activate()
    GameRules.Event = CEventGameMode()
    GameRules.Event:InitGameMode()
end
---[[
-- 用于游戏初始化
function CEventGameMode:InitGameMode()
    -- print("CEventGameMode:InitGameMode is loaded.")

    -- 监听事件
    ListenToGameEvent("game_rules_state_change",
                      Dynamic_Wrap(CEventGameMode, "OnGameRulesStateChange"),
                      self)
    --[[
    -- 监听单位被击杀的事件
    ListenToGameEvent("entity_killed",
                      Dynamic_Wrap(CEventGameMode, "OnEntityKilled"), self)

    -- 同一事件名可以有不同的函数，但是基本没这个必要
    ListenToGameEvent("entity_killed",
                      Dynamic_Wrap(CEventGameMode, "OnEntityKilledHero"), self)

    -- 监听玩家断开连接的事件
    ListenToGameEvent("player_disconnect",
                      Dynamic_Wrap(CEventGameMode, "OnPlayerDisconnect"), self)

    -- 监听物品被购买的事件
    ListenToGameEvent("dota_item_purchased",
                      Dynamic_Wrap(CEventGameMode, "OnDotaItemPurchased"), self)

    -- 监听玩家聊天事件
    ListenToGameEvent("player_chat", Dynamic_Wrap(CEventGameMode, "PlayerChat"),
                      self)
    --]]

    -- 监听玩家选择英雄
    ListenToGameEvent("dota_player_pick_hero",
                      Dynamic_Wrap(CEventGameMode, "OnPlayerPickHero"), self)
    -- 监听单位重生或者创建事件
    ListenToGameEvent("npc_spawned",
                      Dynamic_Wrap(CEventGameMode, "OnNPCSpawned"), self)
    -- 监听单位受到伤害事件
    ListenToGameEvent("entity_hurt",
                      Dynamic_Wrap(CEventGameMode, "OnEntityHurt"), self)
    -- 设置伤害过滤器
    GameRules:GetGameModeEntity():SetDamageFilter(
        Dynamic_Wrap(CEventGameMode, "DamageFilter"), self)
    -- 设置选择英雄时间
    GameRules:SetHeroSelectionTime(30)
    -- 设置决策时间
    GameRules:SetStrategyTime(0)
    -- 设置展示时间
    GameRules:SetShowcaseTime(0)
    -- 设置游戏准备时间
    GameRules:SetPreGameTime(0)
    -- 设置不能买活
    GameRules:GetGameModeEntity():SetBuybackEnabled(false)
    -- 设置复活时间
    GameRules:GetGameModeEntity():SetFixedRespawnTime(10.0)
    -- 设置金钱每次增长
    -- GameRules:SetGoldPerTick(3)
    -- 设置金钱增长间隔
    -- GameRules:SetGoldTickTime(1)
    -- 设置每个队伍人数
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 3)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 3)
    -- 设置泉水不回蓝
    -- GameRules:GetGameModeEntity():SetFountainConstantManaRegen(0)
    -- GameRules:GetGameModeEntity():SetFountainPercentageManaRegen(0)
    -- 可重复选英雄
    -- GameRules:SetSameHeroSelectionEnabled(true)

    -- 垃圾回收
    GameRules:GetGameModeEntity():SetContextThink(
        DoUniqueString("collectgarbage"), function()
            collectgarbage("collect")
            return 300
        end, 120)

    GameRules:GetGameModeEntity():SetThink("OnThink", self, 1)
end

function CEventGameMode:OnGameRulesStateChange(keys)
    -- DeepPrintTable(keys)
    -- 获取游戏进度
    local newState = GameRules:State_Get()

    if newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
        -- print("Player begin select hero") -- 玩家处于选择英雄界面

    elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then
        -- print("Player ready game begin") -- 玩家处于游戏准备状态
        -- MakeRandomHeroSelection()

    elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then

        -- 游戏开始后生成战斗前哨
        local vec = Vector(0, 0, 128)
        local unit_battle_outpost = Utils:create_unit_simple(
                                        "unit_battle_outpost", vec, true,
                                        DOTA_TEAM_CUSTOM_1)
        -- 设置位置与朝向
        unit_battle_outpost:SetOrigin(vec)
        unit_battle_outpost:SetForwardVector(Vector(-1, -1, 0))
        -- 设置动作
        unit_battle_outpost:StartGestureWithPlaybackRate(
            ACT_DOTA_CHANNEL_ABILITY_1, 1)
        -- 设置视野单位,获取战斗前哨视野
        -- local vision_good = Utils:create_unit_simple("npc_dummy_unit", vec,
        --                                              false, DOTA_TEAM_GOODGUYS)
        -- local vision_bad = Utils:create_unit_simple("npc_dummy_unit", vec,
        --                                             false, DOTA_TEAM_BADGUYS)
        -- vision_good:AddNewModifier(vision_good, nil, "modifier_outpost_vision",
        --                            {duration = -1})
        -- vision_bad:AddNewModifier(vision_bad, nil, "modifier_outpost_vision",
        --                           {duration = -1})
        -- 视野单位跟随战斗前哨
        -- vision_good:FollowEntity(unit_battle_outpost, true)
        -- vision_bad:FollowEntity(unit_battle_outpost, true)
        -- print("Player game begin") -- 玩家开始游戏

    end
end
--[[
function CEventGameMode:OnEntityKilled(keys)
    print("OnEntityKilled")
    DeepPrintTable(keys) -- 详细打印传递进来的表
end

function CEventGameMode:OnEntityKilledHero(keys)
    print("OnEntityKilledHero")
    DeepPrintTable(keys) -- 详细打印传递进来的表
end

function CEventGameMode:OnPlayerDisconnect(keys)
    print("OnPlayerDisconnect")
    DeepPrintTable(keys) -- 详细打印传递进来的表
end

function CEventGameMode:OnDotaItemPurchased(keys)
    print("OnDotaItemPurchased")
    DeepPrintTable(keys) -- 详细打印传递进来的表
end

function CEventGameMode:PlayerChat(keys)
    print("PlayerSay")
    DeepPrintTable(keys) -- 详细打印传递进来的表
end
--]]

-- 英雄造成和收到伤害时加能量
function CEventGameMode:OnEntityHurt(keys)
    local attacker = EntIndexToHScript(keys.entindex_attacker)
    local killed = EntIndexToHScript(keys.entindex_killed)
    local damage = keys.damage
    local attacker_level = attacker:GetLevel()
    local attacker_add_energy = damage /
                                    (GameRules.load_kv["base_energy"] +
                                        attacker_level *
                                        GameRules.load_kv["lvl_energy"])
    local killed_level = killed:GetLevel()
    local killed_add_energy = damage /
                                  (GameRules.load_kv["base_energy"] +
                                      killed_level *
                                      GameRules.load_kv["lvl_energy"])
    if attacker:IsHero() then
        attacker.energy = attacker.energy + attacker_add_energy
        if attacker.energy >= 100 then attacker.energy = 100 end
    end

    if killed:IsHero() then
        killed.energy = killed.energy + killed_add_energy
        if killed.energy >= 100 then killed.energy = 100 end
    end
end

-- 英雄选择
function CEventGameMode:OnPlayerPickHero(keys)

    local player = EntIndexToHScript(keys.player)
    -- DeepPrintTable(player)
    local hero = player:GetAssignedHero()
    -- print(hero:GetUnitName())
    local hero = EntIndexToHScript(keys.heroindex)
    -- 初始化英雄的能量
    hero.energy = 0
    -- 添加自动获取能量buff,hero.energy
    hero:AddNewModifier(hero, nil, "modifier_energy", {duration = -1})
    -- 添加获取最近15秒被谁攻击,hero.get_attacker
    hero:AddNewModifier(hero, nil, "modifier_get_attacker", {duration = -1})
    -- 设置能量获取技能等级为1
    local ability_count = hero:GetAbilityCount()
    for i = 1, ability_count do
        local ability = hero:GetAbilityByIndex(i)
        if ability and ability:GetAbilityName() == "energy" then
            ability:SetLevel(1)
            break
        end
    end
end

-- 单位出生
function CEventGameMode:OnNPCSpawned(keys)

    local hero = EntIndexToHScript(keys.entindex)
    if hero:IsHero() then
        -- 初次重生,初始化玩家信息
        if hero.is_first_spawn == nil then
            hero.is_first_spawn = false
            local player_id = hero:GetPlayerID()
            if player_id then
                if GameRules.player_data[player_id] == nil then
                    GameRules.player_data[player_id] = {}
                    GameRules.player_count = GameRules.player_count + 1
                end
            end
            -- 移除天赋技能
            for i = 0, 23 do
                local ability = hero:GetAbilityByIndex(i)
                if ability then
                    local name = ability:GetAbilityName()
                    if string.find(name, "special_bonus") then
                        hero:RemoveAbility(name)
                    end
                end
            end
        end

    end

end

-- 伤害过滤器
function CEventGameMode:DamageFilter(damageTable)
    if not damageTable.entindex_attacker_const and
        damageTable.entindex_victim_const then return true end

    local attacker = EntIndexToHScript(damageTable.entindex_attacker_const)
    local victim = EntIndexToHScript(damageTable.entindex_victim_const)

    -- 获取攻击者
    victim.get_attacker = attacker

    -- 处理圣盾的防御姿态技能
    if victim:HasAbility('defensive_attitude') and
        victim:HasModifier('modifier_defensive_attitude_self_buff') then
        if not damageTable.entindex_inflictor_const then
            -- 获取单位位置
            local victim_origin = victim:GetOrigin()
            local attacker_origin = attacker:GetOrigin()
            -- 获取被攻击者到攻击者的单位向量
            local victim_to_attacker =
                (attacker_origin - victim_origin):Normalized()
            -- 获取被攻击者朝向的单位向量
            local victim_forword = victim:GetForwardVector():Normalized()
            -- 计算向量夹角
            local angle =
                Utils:getAngleByPos(victim_to_attacker, victim_forword)
            -- 被攻击者是否面对攻击者
            if angle <= 90 then
                local ability = victim:FindAbilityByName('defensive_attitude')
                local damage_block_percent =
                    ability:GetLevelSpecialValueFor("reduce_percent",
                                                    ability:GetLevel() - 1) /
                        100
                damageTable.damage = (1 - damage_block_percent) *
                                         damageTable.damage
                EmitSoundOn("Hero_Mars.Shield.Block", victim)
            end
        end
    end

    -- 处理不灭灵魂的灵魂连接技能
    if victim:HasModifier('modifier_soul_connection_target') then
        if not damageTable.entindex_inflictor_const then
            -- 获取灵魂连接施法者和技能实体
            if victim.soul_conn_caster and victim.soul_conn_ability then
                local ability = victim.soul_conn_ability
                local transfer_damage_percent =
                    ability:GetLevelSpecialValueFor("transfer_damage_percent",
                                                    ability:GetLevel() - 1) /
                        100
                -- 减伤
                damageTable.damage = (1 - transfer_damage_percent) *
                                         damageTable.damage
                -- 伤害转移
                local damage_type = damageTable.damagetype_const
                if damage_type then
                    local damage_table =
                        {
                            victim = victim.soul_conn_caster,
                            attacker = attacker,
                            damage = transfer_damage_percent *
                                damageTable.damage,
                            damage_type = damage_type
                        }
                    ApplyDamage(damage_table)
                end
            end
        end
    end

    -- 处理不灭灵魂的不灭技能
    if victim:HasAbility('immortal') then
        local ability = victim:FindAbilityByName("immortal")
        if ability:GetLevel() >= 1 and
            not victim:HasModifier('modifier_immortal_cd') then
            if not damageTable.entindex_inflictor_const then
                local hp = victim:GetHealth() - damageTable.damage
                if hp <= 0 then
                    -- 没生效则加生效buff
                    if not victim:HasModifier("modifier_immortal_apply") then
                        -- 生效buff结束后自动加计时buff
                        ability:ApplyDataDrivenModifier(victim, victim,
                                                        "modifier_immortal_apply",
                                                        {})
                    end
                    -- 最低生命为1
                    victim:SetHealth(1)
                    damageTable.damage = 0
                end
            end
        end
    end
    if attacker:HasAbility('immortal') then
        local ability = attacker:FindAbilityByName("immortal")
        if ability:GetLevel() >= 1 and
            attacker:HasModifier("modifier_immortal_apply") then
            local life_steal_percent = ability:GetLevelSpecialValueFor(
                                           "life_steal_percent",
                                           ability:GetLevel() - 1) / 100
            local heal = damageTable.damage * life_steal_percent
            -- 回血加特效
            attacker:Heal(heal, attacker)
            ParticleManager:CreateParticle(
                "particles/items3_fx/octarine_core_lifesteal.vpcf",
                PATTACH_ABSORIGIN_FOLLOW, caster)
        end
    end

    return true
end

-- Evaluate the state of the game
function CEventGameMode:OnThink()
    -- 玩家数大于0
    if GameRules.player_count > 0 then
        local show_socre_event = {hero_name = "Mit", hero_energy = "9999"}
        CustomGameEventManager:Send_ServerToAllClients("show_score",
                                                       show_socre_event)
    end
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        -- print( "Template addon script is running." )
    elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
        return nil
    end
    return 1
end
