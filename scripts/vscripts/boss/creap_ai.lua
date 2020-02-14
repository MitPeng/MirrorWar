LinkLuaModifier( "modifier_creature_passive", "modifiers/modifier_creature_passive", LUA_MODIFIER_MOTION_NONE )

nWalkingMoveSpeed=140


function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

    if thisEntity:GetLevel() then
		local nLevel= thisEntity:GetLevel()     
		thisEntity:SetHullRadius(7+nLevel*4)  --体型跟随等级线性增加 6可以通过 7级不可以
	end
    

    --被攻击时间
    thisEntity:AddNewModifier(thisEntity, nil, "modifier_creature_passive", {})


    -- 以下内容 对玩家无效
    if thisEntity:GetTeam()~=DOTA_TEAM_NEUTRALS then
       return
    end

    thisEntity:SetAcquisitionRange(500)
    
    --保存初始移动速度
    thisEntity.nOriginalMovementSpeed=thisEntity:GetBaseMoveSpeed()
    --降低移动速度
    thisEntity:SetBaseMoveSpeed(nWalkingMoveSpeed)

	thisEntity:SetContextThink( "CreepThink", CreepThink, 0.5 )
end

function CreepThink()

	-- 对玩家无效
    if thisEntity:GetTeam()~=DOTA_TEAM_NEUTRALS then
       return
    end

    if thisEntity.vWaypoints==nil then

	    thisEntity.vWaypoints = {}
	    --画一个漫步的行走方向
	    local currentWayPoint = thisEntity:GetAbsOrigin()
		while #thisEntity.vWaypoints < 15 do
			local waypoint = currentWayPoint + RandomVector( RandomFloat( 0, 2048 ) )
			if GridNav:CanFindPath( thisEntity:GetAbsOrigin(), waypoint ) then
				table.insert( thisEntity.vWaypoints, waypoint )
				currentWayPoint=waypoint
			end
		end
		
	end

    if not thisEntity:IsAlive() then
		return
	end
	if GameRules:IsGamePaused() then
		return 0.1
	end

    --如果正在施法，先等一等
    if thisEntity:IsChanneling() then
		return 0.1
	end

	local agro = CheckIfHasAggro()
	if agro then
		return agro
	end
	return RoamBetweenWaypoints()

end


function CheckIfHasAggro()

	--如果有追击目标
    if thisEntity.hChasingTarget and not thisEntity.hChasingTarget:IsNull()  then

    	local flAbilityCastTime = TryCastAbility(thisEntity.hChasingTarget)
    	--先放技能 其他操作下个循环再说
        if flAbilityCastTime then
        	return flAbilityCastTime
        end

        --基础追击时间 4秒
        local flChaseTime=CalculateChasingTime()

		if (thisEntity.flLastHitTime and ( GameRules:GetGameTime() - thisEntity.flLastHitTime >flChaseTime ) )  then
	 		--撤退 并且重置追击状态
	 		return RetreatFromUnit(thisEntity.hChasingTarget)
		end
		thisEntity:SetAggroTarget(thisEntity.hChasingTarget)
		return 0.5
    else
		if thisEntity:GetAggroTarget() ~= nil then
			local hTarget = thisEntity:GetAggroTarget()
			--低级生物保护
            if CheckAggroTarget(hTarget) then
            	--新增追击目标
		        if not thisEntity.hChasingTarget then
		        	thisEntity.hChasingTarget=hTarget
		        	thisEntity:SetBaseMoveSpeed( thisEntity.nOriginalMovementSpeed )
		            thisEntity.flLastHitTime =  GameRules:GetGameTime()
		        end
		        local flAbilityCastTime = TryCastAbility(hTarget)
	            if flAbilityCastTime then
	            	return flAbilityCastTime
	            else
	            	return 0.1
	            end
	        else
	        	RoamNonAggressive()
	        end
		else
			--恢复步行速度
			thisEntity:SetBaseMoveSpeed(nWalkingMoveSpeed)
			return nil
		end
	end
end
------------------------------------------------------------------
--尝试释放技能
function TryCastAbility(hTarget)

 	local bWillCastAbility = true

    --11级生物 不主动释放技能
 	if thisEntity:GetLevel()>10 and thisEntity.hLastAttacker~=hTarget then
        bWillCastAbility=false
 	end

 	--同级生物 不主动释放技能
 	if thisEntity:GetLevel()==hTarget:GetLevel() and thisEntity.hLastAttacker~=hTarget then
        bWillCastAbility=false
 	end
 	
    if bWillCastAbility then
	 	local flAbilityCastTime = CastAbility(hTarget)
	 	if flAbilityCastTime then
	 		return flAbilityCastTime
	 	end
	end
	return nil
end

-------------------------------------------------------------------

function ContainsValue(nSum,nValue)

	if bit:_and(nSum,nValue)==nValue then
        return true
    else
    	return false
    end

end


-------------------------------------------------------------------

function CastAbility(hTarget)
    
    for i=1,20 do
        local hAbility=thisEntity:GetAbilityByIndex(i-1)
        if  hAbility and not hAbility:IsPassive() and hAbility:IsFullyCastable() then
        	--目标类技能 (法球不算)
        	if ContainsValue(hAbility:GetBehavior(),DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) and not ContainsValue(hAbility:GetBehavior(),DOTA_ABILITY_BEHAVIOR_ATTACK) then
        		--对敌人使用的目标技能
        		if ContainsValue(hAbility:GetAbilityTargetTeam(),DOTA_UNIT_TARGET_TEAM_ENEMY) or ContainsValue(hAbility:GetAbilityTargetTeam(),DOTA_UNIT_TARGET_TEAM_CUSTOM) then
					    ExecuteOrderFromTable({
							UnitIndex = thisEntity:entindex(),
							OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
							AbilityIndex = hAbility:entindex(),
					        TargetIndex = hTarget:entindex()
						})
						return hAbility:GetCastPoint()+RandomFloat(0.1, 0.3)
                end
                -- 对自己释放的目标技能（此处忽略野怪之间互相buff）
                if ContainsValue(hAbility:GetAbilityTargetTeam(),DOTA_UNIT_TARGET_TEAM_FRIENDLY) then
					    ExecuteOrderFromTable({
							UnitIndex = thisEntity:entindex(),
							OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
							AbilityIndex = hAbility:entindex(),
					        TargetIndex = thisEntity:entindex()
						})
				    return hAbility:GetCastPoint()+RandomFloat(0.1, 0.3)
                end
        	end

        	--点技能
        	if ContainsValue(hAbility:GetBehavior(),DOTA_ABILITY_BEHAVIOR_POINT) then
        		--伤害类技能 对敌人扔
				local vLeadingOffset = hTarget:GetForwardVector() * RandomInt( 100, 300 )
                local vTargetPos = hTarget:GetOrigin() + vLeadingOffset
			    ExecuteOrderFromTable({
					UnitIndex = thisEntity:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					Position =  vTargetPos,
					AbilityIndex = hAbility:entindex(),
				})
				return hAbility:GetCastPoint()+RandomFloat(0.1, 0.3)
        	end

        	--无目标非切换技能 直接乱放
        	if ContainsValue(hAbility:GetBehavior(),DOTA_ABILITY_BEHAVIOR_NO_TARGET) and not ContainsValue(hAbility:GetBehavior(),DOTA_ABILITY_BEHAVIOR_AUTOCAST) then
    				
			    ExecuteOrderFromTable({
					UnitIndex = thisEntity:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = hAbility:entindex(),
				})
				return hAbility:GetCastPoint()+RandomFloat(0.1, 0.3)
        	end

        	--自动释放的技能，切换成自动释放
        	if ContainsValue(hAbility:GetBehavior(),DOTA_ABILITY_BEHAVIOR_AUTOCAST) then   		    
    		   if not hAbility:GetAutoCastState() then
                  hAbility:ToggleAutoCast()
    		   end
        	end
        end
    end

end

--------------------------------------------------------------------

function RetreatFromUnit(hUnit)
    
    thisEntity:SetBaseMoveSpeed( nWalkingMoveSpeed )
    
    --清除仇恨
    thisEntity.hLastAttacker=nil
    thisEntity:SetAggroTarget(nil)
	thisEntity.hChasingTarget=nil

    --如果单位被定身，只放弃攻击 不撤退
    if not thisEntity:IsRooted() then

		    local vAwayFromEnemy= thisEntity:GetOrigin() - RandomVector(100)

		    if not hUnit:IsNull() and  hUnit:IsAlive() then
			   vAwayFromEnemy = thisEntity:GetOrigin() - hUnit:GetOrigin()
		    end
			vAwayFromEnemy = vAwayFromEnemy:Normalized()

			local vMoveToPos = thisEntity:GetOrigin() + vAwayFromEnemy * nWalkingMoveSpeed*1.75

			-- if away from enemy is an unpathable area, find a new direction to run to
			local nAttempts = 0
			while ( ( not GridNav:CanFindPath( thisEntity:GetOrigin(), vMoveToPos ) ) and ( nAttempts < 5 ) ) do
				vMoveToPos = thisEntity:GetOrigin() + RandomVector( nWalkingMoveSpeed*1.75 )
				nAttempts = nAttempts + 1
			end

			ExecuteOrderFromTable({
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				Position = vMoveToPos,
			})

			return 1.75
	else
            return 0.8
	end
 
end
--------------------------------------------------------------------------------
-- RoamBetweenWaypoints
--------------------------------------------------------------------------------
function RoamBetweenWaypoints()
	local flGameTime = GameRules:GetGameTime()

	if thisEntity.targetWayPoint ~= nil then
		local flRoamTimeLeft = thisEntity.flNextWaypointTime - flGameTime
		--如果到了 游荡时间 或者抵达目的地 换目标点
		if flRoamTimeLeft <= 0 or (thisEntity.targetWayPoint-thisEntity:GetAbsOrigin()):Length2D()<100 then
			thisEntity.targetWayPoint = nil
		end
	end
	if thisEntity.targetWayPoint == nil then
	   thisEntity.targetWayPoint = thisEntity.vWaypoints[ RandomInt( 1, #thisEntity.vWaypoints ) ]
	   thisEntity.flNextWaypointTime = flGameTime + RandomFloat( 5, 10 ) * thisEntity:GetLevel() --高级怪多走两步
	   thisEntity:MoveToPositionAggressive( thisEntity.targetWayPoint )
	end
	return thisEntity:GetAttackAnimationPoint()
end
--------------------------------------------------------------------------------------
--低级玩家保护，非攻击性游走
function RoamNonAggressive()

	local flGameTime = GameRules:GetGameTime()
	if thisEntity.targetWayPoint ~= nil then
		thisEntity:MoveToPosition( thisEntity.targetWayPoint )
	end
	thisEntity:SetAggroTarget(nil)
	thisEntity.hChasingTarget=nil

	return RandomFloat( 0.5, 1.0 )
end



---低级玩家保护
function CheckAggroTarget(hTarget)
    
    if hTarget==nil or hTarget:IsNull() or (not hTarget:IsAlive()) then
        return false
    end

    --PVE模式无保护
    if GameRules.bPveMap then
    	return true
    end

 	if hTarget.GetOwner and hTarget:GetOwner() and hTarget:GetOwner().GetPlayerID and hTarget:GetOwner():GetPlayerID() then
        local nPlayerId = hTarget:GetOwner():GetPlayerID()
        local hHero =  PlayerResource:GetSelectedHeroEntity(nPlayerId)

        --如果目标是玩家主控生物,并且低于平均等级1级，怪物不主动攻击
        if hHero and hHero.hCurrentCreep == hTarget and GameRules.nAverageLevel then
             if hHero.nCurrentCreepLevel <= (GameRules.nAverageLevel-1)  and  thisEntity.hLastAttacker~=hTarget  then
                 return false
             end
        end

        --如果目标是玩家主控生物,等级等于平均等级  怪物不会主动攻击等级比自己低的生物
        if hHero and hHero.hCurrentCreep == hTarget and GameRules.nAverageLevel then
             if hHero.nCurrentCreepLevel == GameRules.nAverageLevel and thisEntity.hLastAttacker~=hTarget  then
                 if thisEntity:GetLevel()>hHero.nCurrentCreepLevel then
                  	 return false
                 end
             end
        end
    end
	
    return true
	
end


---计算追逐时间
function CalculateChasingTime()
    
    --如果x秒不受玩家反击，或者丢失玩家视野 (保证其能移动，不能移动的单位不撤退)
    --  基础追击时间 4秒
    local flChaseTime=4
    
    -- 降低11级生物的仇恨时间
    if thisEntity:GetLevel()==11 then
       flChaseTime=3
    end

    --调整追击时间
    if GameRules.nAverageLevel then
       if thisEntity.hChasingTarget:GetLevel() >= GameRules.nAverageLevel +3 then                  
           flChaseTime = 13
       end
       if thisEntity.hChasingTarget:GetLevel() == GameRules.nAverageLevel +2 then                  
           flChaseTime = 9
       end
       if thisEntity.hChasingTarget:GetLevel() == GameRules.nAverageLevel +1 then                  
           flChaseTime = 6
       end
       if thisEntity.hChasingTarget:GetLevel() == GameRules.nAverageLevel then                  
           flChaseTime = 4
       end 
       if thisEntity.hChasingTarget:GetLevel() == GameRules.nAverageLevel -1  then                  
           flChaseTime = 2.25
       end
       if thisEntity.hChasingTarget:GetLevel() == GameRules.nAverageLevel -2  then                  
           flChaseTime = 1.5   
       end
       if thisEntity.hChasingTarget:GetLevel() <= GameRules.nAverageLevel -3  then                  
           flChaseTime = 0.75  
       end
    end

    return flChaseTime

end
