require("timers")
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

end
LinkLuaModifier("modifier_energy", "modifiers/modifier_energy.lua",
                LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_get_attacker", "modifiers/modifier_get_attacker.lua",
                LUA_MODIFIER_MOTION_NONE)

-- 英雄饰品
GameRules.npc_wears_custom = LoadKeyValues("scripts/npc/npc_wears_custom.txt")
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

    GameRules:GetGameModeEntity():SetThink("OnThink", self, "GlobalThink", 2)
end

function CEventGameMode:OnGameRulesStateChange(keys)

    -- 获取游戏进度
    local newState = GameRules:State_Get()

    if newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
        print("Player begin select hero") -- 玩家处于选择英雄界面

    elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then
        print("Player ready game begin") -- 玩家处于游戏准备状态

    elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then

        -- 游戏开始后生成战斗前哨
        local vec = Vector(0, 0, 128)
        local item_battle_outpost = CreateUnitByName("item_battle_outpost", vec,
                                                     true, nil, nil,
                                                     DOTA_TEAM_CUSTOM_1)
        item_battle_outpost:SetOrigin(vec)
        local count = item_battle_outpost:GetAbilityCount()
        for i = 0, count - 1 do
            ability = item_battle_outpost:GetAbilityByIndex(i)
            if ability then ability:SetLevel(1) end
        end

        print("Player game begin") -- 玩家开始游戏

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
    local damage = keys.damage
    local add_energy = damage / 100
    if attacker:IsHero() then
        attacker.energy = attacker.energy + add_energy
        if attacker.energy >= 100 then attacker.energy = 100 end
    end
    local killed = EntIndexToHScript(keys.entindex_killed)
    if killed:IsHero() then
        killed.energy = killed.energy + add_energy
        if killed.energy >= 100 then killed.energy = 100 end
    end
end

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
        end
    end

end

-- Evaluate the state of the game
function CEventGameMode:OnThink()
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        -- print( "Template addon script is running." )
    elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
        return nil
    end
    return 1
end
