AI = {}

AI.Init = function(self)
    -- Defer the initialization to first tick, to allow spawners to set state.
    self.aiState = {
        hAggroTarget = nil,
        flShoutRange = 100,
        nWalkingMoveSpeed = 140,
        nAggroMoveSpeed = self:GetBaseMoveSpeed(),
        flAcquisitionRange = 600,
        vTargetWaypoint = nil,
        isAttacking = false
    }
    self:SetContextThink("init_think", function()
        self.aiThink = aiThink
        self.CheckIfHasAggro = CheckIfHasAggro
        self.RoamBetweenWaypoints = RoamBetweenWaypoints
        self:SetAcquisitionRange(self.aiState.flAcquisitionRange)
        self.bIsRoaring = false

        local tWaypoints = {}
        local nWaypointsPerRoamNode = 10
        local nMinWaypointSearchDistance = 0
        local nMaxWaypointSearchDistance = 2048

        while #tWaypoints < nWaypointsPerRoamNode do
            local vWaypoint = self:GetAbsOrigin() +
                                  RandomVector(
                                      RandomFloat(nMinWaypointSearchDistance,
                                                  nMaxWaypointSearchDistance))
            if GridNav:CanFindPath(self:GetAbsOrigin(), vWaypoint) then
                table.insert(tWaypoints, vWaypoint)
            end
        end
        self.aiState.tWaypoints = tWaypoints
        self:SetContextThink("ai_base_creature.aiThink",
                             Dynamic_Wrap(self, "aiThink"), 0)
    end, 0)
end

function Spawn(entityKeyValues) AI.Init(thisEntity) end

function aiThink(self)
    if not self:IsAlive() then return end
    if GameRules:IsGamePaused() then return 0.1 end
    -- 如果正在施法，先等一等
    if thisEntity:IsChanneling() then return 0.1 end
    local agro = self:CheckIfHasAggro()
    if agro then return agro end
    return self:RoamBetweenWaypoints()
end

--------------------------------------------------------------------------------
-- CheckIfHasAggro
--------------------------------------------------------------------------------
function CheckIfHasAggro(self)
    if self:GetAggroTarget() ~= nil then
        self:SetBaseMoveSpeed(self.aiState.nAggroMoveSpeed)
        if self:GetAggroTarget() ~= self.aiState.hAggroTarget then
            self.aiState.hAggroTarget = self:GetAggroTarget()
        end

        local flAbilityCastTime = TryCastAbility(thisEntity.hAggroTarget)
        -- 先放技能 其他操作下个循环再说
        if flAbilityCastTime then return flAbilityCastTime end

        if not self.aiState.isAttacking then
            self.aiState.ChasingStartPos = self:GetAbsOrigin()
            self.aiState.isAttacking = true
        else
            local distance =
                (self:GetAbsOrigin() - self.aiState.ChasingStartPos):Length2D()
            if distance > 2000 then
                self:MoveToPosition(self.aiState.ChasingStartPos)
                return distance / 200
            end
        end

        return RandomFloat(0.5, 1)
    else
        self:SetBaseMoveSpeed(self.aiState.nWalkingMoveSpeed)
        self.bIsRoaring = false
        return nil
    end
end

------------------------------------------------------------------
-- 尝试释放技能
function TryCastAbility(hTarget)

    local bWillCastAbility = true

    -- 11级生物 不主动释放技能
    if thisEntity:GetLevel() > 10 and thisEntity.hLastAttacker ~= hTarget then
        bWillCastAbility = false
    end

    -- 同级生物 不主动释放技能
    if thisEntity:GetLevel() == hTarget:GetLevel() and thisEntity.hLastAttacker ~=
        hTarget then bWillCastAbility = false end

    if bWillCastAbility then
        local flAbilityCastTime = CastAbility(hTarget)
        if flAbilityCastTime then return flAbilityCastTime end
    end
    return nil
end
-------------------------------------------------------------------

function CastAbility(hTarget)

    for i = 1, 20 do
        local hAbility = thisEntity:GetAbilityByIndex(i - 1)
        if hAbility and not hAbility:IsPassive() and hAbility:IsFullyCastable() then
            -- 目标类技能 (法球不算)
            if ContainsValue(hAbility:GetBehavior(),
                             DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) and
                not ContainsValue(hAbility:GetBehavior(),
                                  DOTA_ABILITY_BEHAVIOR_ATTACK) then
                -- 对敌人使用的目标技能
                if ContainsValue(hAbility:GetAbilityTargetTeam(),
                                 DOTA_UNIT_TARGET_TEAM_ENEMY) or
                    ContainsValue(hAbility:GetAbilityTargetTeam(),
                                  DOTA_UNIT_TARGET_TEAM_CUSTOM) then
                    ExecuteOrderFromTable(
                        {
                            UnitIndex = thisEntity:entindex(),
                            OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
                            AbilityIndex = hAbility:entindex(),
                            TargetIndex = hTarget:entindex()
                        })
                    return hAbility:GetCastPoint() + RandomFloat(0.1, 0.3)
                end
                -- 对自己释放的目标技能（此处忽略野怪之间互相buff）
                if ContainsValue(hAbility:GetAbilityTargetTeam(),
                                 DOTA_UNIT_TARGET_TEAM_FRIENDLY) then
                    ExecuteOrderFromTable(
                        {
                            UnitIndex = thisEntity:entindex(),
                            OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
                            AbilityIndex = hAbility:entindex(),
                            TargetIndex = thisEntity:entindex()
                        })
                    return hAbility:GetCastPoint() + RandomFloat(0.1, 0.3)
                end
            end

            -- 点技能
            if ContainsValue(hAbility:GetBehavior(), DOTA_ABILITY_BEHAVIOR_POINT) then
                -- 伤害类技能 对敌人扔
                local vLeadingOffset = hTarget:GetForwardVector() *
                                           RandomInt(100, 300)
                local vTargetPos = hTarget:GetOrigin() + vLeadingOffset
                ExecuteOrderFromTable({
                    UnitIndex = thisEntity:entindex(),
                    OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
                    Position = vTargetPos,
                    AbilityIndex = hAbility:entindex()
                })
                return hAbility:GetCastPoint() + RandomFloat(0.1, 0.3)
            end

            -- 无目标非切换技能 直接乱放
            if ContainsValue(hAbility:GetBehavior(),
                             DOTA_ABILITY_BEHAVIOR_NO_TARGET) and
                not ContainsValue(hAbility:GetBehavior(),
                                  DOTA_ABILITY_BEHAVIOR_AUTOCAST) then

                ExecuteOrderFromTable({
                    UnitIndex = thisEntity:entindex(),
                    OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
                    AbilityIndex = hAbility:entindex()
                })
                return hAbility:GetCastPoint() + RandomFloat(0.1, 0.3)
            end

            -- 自动释放的技能，切换成自动释放
            if ContainsValue(hAbility:GetBehavior(),
                             DOTA_ABILITY_BEHAVIOR_AUTOCAST) then
                if not hAbility:GetAutoCastState() then
                    hAbility:ToggleAutoCast()
                end
            end
        end
    end

end

--------------------------------------------------------------------------------
-- RoamBetweenWaypoints
--------------------------------------------------------------------------------
function RoamBetweenWaypoints(self)
    local gameTime = GameRules:GetGameTime()
    local aiState = self.aiState
    if aiState.vWaypoint ~= nil then
        local flRoamTimeLeft = aiState.flNextWaypointTime - gameTime
        if flRoamTimeLeft <= 0 then aiState.vWaypoint = nil end
    end
    if aiState.vWaypoint == nil then
        aiState.vWaypoint =
            aiState.tWaypoints[RandomInt(1, #aiState.tWaypoints)]
        aiState.flNextWaypointTime = gameTime + RandomFloat(2, 4)
        self:MoveToPositionAggressive(aiState.vWaypoint)
    end
    return RandomFloat(0.5, 1.0)
end
