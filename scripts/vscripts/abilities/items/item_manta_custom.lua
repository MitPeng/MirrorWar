LinkLuaModifier("modifier_item_manta_custom", "abilities/items/item_manta_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_manta_custom_invuln", "abilities/items/item_manta_custom.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_manta_custom == nil then
	item_manta_custom = class({})
end
function item_manta_custom:CastFilterResult()
	if not self:GetCaster():HasModifier("modifier_building") then
		return UF_FAIL_CUSTOM
	end
	return UF_SUCCESS
end
function item_manta_custom:GetCustomCastError()
	return "dota_hud_error_only_building_can_use"
end
function item_manta_custom:OnSpellStart()
	
	local illusion_num = self:GetSpecialValueFor("illusion_num")
	local illusion_damage_pct = self:GetSpecialValueFor("illusion_damage_pct")
	local illusion_damage_pct_ranged = self:GetSpecialValueFor("illusion_damage_pct_ranged")
	local illusion_duration = self:GetSpecialValueFor("illusion_duration")
	local illusion_duration_ranged = self:GetSpecialValueFor("illusion_duration_ranged")
	local invuln_duration = self:GetSpecialValueFor("invuln_duration")
	
	local hCaster = self:GetParent()

	hCaster:Purge(false, true, false, false, false)

	local hHero = PlayerResource:GetSelectedHeroEntity(hCaster:GetPlayerOwnerID())
	illusion_damage_pct = hCaster:IsRangedAttacker() and illusion_damage_pct_ranged or illusion_damage_pct
	local manta_illusion_table = Load(hCaster, "manta_illusion_table") or {}
	if manta_illusion_table ~= nil then
		for index = #manta_illusion_table, 1, -1 do
			if IsValid(manta_illusion_table[index]) then
				manta_illusion_table[index]:ForceKill(false)
				table.remove(manta_illusion_table, index)
			end
		end
	end
	Save(hCaster, "manta_illusion_table", manta_illusion_table)

	local fHullRadius = hCaster:GetHullRadius()
	local fDistance = 64 + fHullRadius
	for i = 1, illusion_num do
		local fDistance_X = (RandomInt(0, 1) == 0) and fDistance or (0 - fDistance)
		fDistance_X = ( i % 2 == 0) and fDistance_X or 0
		local fDistance_Y = (RandomInt(0, 1) == 0) and fDistance or (0 - fDistance)
		fDistance_Y = ( i % 2 == 1) and fDistance_Y or 0
		local vLocation = hCaster:GetAbsOrigin() + Vector(fDistance_X, fDistance_Y, 0)
		local hIllusion = CreateIllusion(hCaster, vLocation, false, hHero, hHero, hCaster:GetTeamNumber(), illusion_duration, illusion_damage_pct-100, 0)

		table.insert(manta_illusion_table, hIllusion)
		Save(hCaster, "manta_illusion_table", manta_illusion_table)

		hIllusion:FireIllusionSummonned(hCaster)

		hIllusion:AddNewModifier(hCaster, self, "modifier_item_manta_custom_invuln", {duration=invuln_duration})
	end

	hCaster:AddNewModifier(hCaster, self, "modifier_item_manta_custom_invuln", {duration=invuln_duration})

	hCaster:EmitSound("DOTA_Item.Manta.Activate")
end
function item_manta_custom:GetIntrinsicModifierName()
	return "modifier_item_manta_custom"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_manta_custom == nil then
	modifier_item_manta_custom = class({})
end
function modifier_item_manta_custom:IsHidden()
	return true
end
function modifier_item_manta_custom:IsDebuff()
	return false
end
function modifier_item_manta_custom:IsPurgable()
	return false
end
function modifier_item_manta_custom:IsPurgeException()
	return false
end
function modifier_item_manta_custom:IsStunDebuff()
	return false
end
function modifier_item_manta_custom:AllowIllusionDuplicate()
	return false
end
function modifier_item_manta_custom:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_item_manta_custom:OnCreated(params)
	local hParent = self:GetParent()
	
	self.bonus_agility = self:GetAbilitySpecialValueFor("bonus_agility")
	self.bonus_intellect = self:GetAbilitySpecialValueFor("bonus_intellect")
	self.bonus_strength = self:GetAbilitySpecialValueFor("bonus_strength")
	self.bonus_attack_speed = self:GetAbilitySpecialValueFor("bonus_attack_speed")

	if IsServer() then
		if hParent:IsBuilding() then
			self:StartIntervalThink(AI_TIMER_TICK_TIME)
			hParent:ModifyAgility(self.bonus_agility)
			hParent:ModifyStrength(self.bonus_strength)
			hParent:ModifyIntellect(self.bonus_intellect)
		end
	end
end
function modifier_item_manta_custom:OnRefresh(params)
	local hParent = self:GetParent()

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyAgility(-self.bonus_agility)
			hParent:ModifyStrength(-self.bonus_strength)
			hParent:ModifyIntellect(-self.bonus_intellect)
		end
	end

	self.bonus_agility = self:GetAbilitySpecialValueFor("bonus_agility")
	self.bonus_intellect = self:GetAbilitySpecialValueFor("bonus_intellect")
	self.bonus_strength = self:GetAbilitySpecialValueFor("bonus_strength")
	self.bonus_attack_speed = self:GetAbilitySpecialValueFor("bonus_attack_speed")

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyAgility(self.bonus_agility)
			hParent:ModifyStrength(self.bonus_strength)
			hParent:ModifyIntellect(self.bonus_intellect)
		end
	end
end
function modifier_item_manta_custom:OnDestroy()
	local hParent = self:GetParent()
	if hParent:IsIllusion() then return end

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyAgility(-self.bonus_agility)
			hParent:ModifyStrength(-self.bonus_strength)
			hParent:ModifyIntellect(-self.bonus_intellect)
		end
	end
end
function modifier_item_manta_custom:OnIntervalThink()
	if IsServer() then
		local ability = self:GetAbility()
		if not IsValid(ability) then
			self:StartIntervalThink(-1)
			return
		end

		local caster = ability:GetCaster()

		if caster:IsTempestDouble() or caster:IsIllusion() then
			self:StartIntervalThink(-1)
			return
		end
		
		local range = caster:Script_GetAttackRange()
		local teamFilter = DOTA_UNIT_TARGET_TEAM_ENEMY
		local typeFilter = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
		local flagFilter = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE+DOTA_UNIT_TARGET_FLAG_NO_INVIS
		local order = FIND_CLOSEST
		local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, range, teamFilter, typeFilter, flagFilter, order, false)
		if targets[1] ~= nil and caster:IsAbilityReady(ability) then
			ExecuteOrderFromTable({
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = ability:entindex(),
			})
		end
	end
end
function modifier_item_manta_custom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end
function modifier_item_manta_custom:GetModifierBonusStats_Agility(params)
	return self.bonus_agility
end
function modifier_item_manta_custom:GetModifierBonusStats_Strength(params)
	return self.bonus_strength
end
function modifier_item_manta_custom:GetModifierBonusStats_Intellect(params)
	return self.bonus_intellect
end
function modifier_item_manta_custom:GetModifierAttackSpeedBonus_Constant(params)
	return self.bonus_attack_speed
end
---------------------------------------------------------------------
if modifier_item_manta_custom_invuln == nil then
	modifier_item_manta_custom_invuln = class({})
end
function modifier_item_manta_custom_invuln:IsHidden()
	return true
end
function modifier_item_manta_custom_invuln:IsDebuff()
	return false
end
function modifier_item_manta_custom_invuln:IsPurgable()
	return false
end
function modifier_item_manta_custom_invuln:IsPurgeException()
	return false
end
function modifier_item_manta_custom_invuln:IsStunDebuff()
	return false
end
function modifier_item_manta_custom_invuln:AllowIllusionDuplicate()
	return false
end
function modifier_item_manta_custom_invuln:GetEffectName()
	return "particles/items2_fx/manta_phase.vpcf"
end
function modifier_item_manta_custom_invuln:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end