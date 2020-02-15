AI = {}

AI.Init = function(self)
    -- Defer the initialization to first tick, to allow spawners to set state.
    self.aiState = {
        hAggroTarget = nil,
        flShoutRange = 100,
        nWalkingMoveSpeed = 200,
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
        local nWaypointsPerRoamNode = 20
        local nMinWaypointSearchDistance = 1024
        local nMaxWaypointSearchDistance = 3072

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
    if self:IsChanneling() then return 0.1 end
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

        return RandomFloat(0.5, 1.0)
    else
        self:SetBaseMoveSpeed(self.aiState.nWalkingMoveSpeed)
        self.bIsRoaring = false
        return nil
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
