LinkLuaModifier("modifier_item_holy_cape", "abilities/items/item_holy_cape.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_holy_cape_aura", "abilities/items/item_holy_cape.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_holy_cape_pure_aura", "abilities/items/item_holy_cape.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_holy_cape == nil then
	item_holy_cape = class({})
end
function item_holy_cape:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("radius")
end
function item_holy_cape:GetIntrinsicModifierName()
	return "modifier_item_holy_cape"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_holy_cape == nil then
	modifier_item_holy_cape = class({})
end
function modifier_item_holy_cape:IsHidden()
	return true
end
function modifier_item_holy_cape:IsDebuff()
	return false
end
function modifier_item_holy_cape:IsPurgable()
	return false
end
function modifier_item_holy_cape:IsPurgeException()
	return false
end
function modifier_item_holy_cape:IsStunDebuff()
	return false
end
function modifier_item_holy_cape:AllowIllusionDuplicate()
	return false
end
function modifier_item_holy_cape:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_item_holy_cape:OnCreated(params)
	local hParent = self:GetParent()

	self.bonus_all_stats = self:GetAbilitySpecialValueFor("bonus_all_stats")
	self.bonus_pure_damage = self:GetAbilitySpecialValueFor("bonus_pure_damage")
	self.threshold_value = self:GetAbilitySpecialValueFor("threshold_value")
	self.radius = self:GetAbilitySpecialValueFor("radius")

	local holy_cape_table = Load(hParent, "holy_cape_table") or {}
	table.insert(holy_cape_table, self)
	Save(hParent, "holy_cape_table", holy_cape_table)

	if holy_cape_table[1] == self then
		self.key = SetOutgoingDamagePercent(hParent, DAMAGE_TYPE_PURE, self.bonus_pure_damage)
	end

	if IsServer() then
		self.bCanNotTrigger = false
		self.fTotalDamage = self:GetAbility():GetCurrentCharges()
		if hParent:IsBuilding() then
			hParent:ModifyStrength(self.bonus_all_stats)
			hParent:ModifyAgility(self.bonus_all_stats)
			hParent:ModifyIntellect(self.bonus_all_stats)
		end

		if holy_cape_table[1] == self then
			self:StartIntervalThink(self:GetAbility():GetCooldownTimeRemaining())
		end
	end

	AddModifierEvents(MODIFIER_EVENT_ON_TAKEDAMAGE, self)
end
function modifier_item_holy_cape:OnRefresh(params)
	local hParent = self:GetParent()

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyStrength(-self.bonus_all_stats)
			hParent:ModifyAgility(-self.bonus_all_stats)
			hParent:ModifyIntellect(-self.bonus_all_stats)
		end
	end

	self.bonus_all_stats = self:GetAbilitySpecialValueFor("bonus_all_stats")
	self.bonus_pure_damage = self:GetAbilitySpecialValueFor("bonus_pure_damage")
	self.threshold_value = self:GetAbilitySpecialValueFor("threshold_value")
	self.radius = self:GetAbilitySpecialValueFor("radius")

	if self.key ~= nil then
		SetOutgoingDamagePercent(hParent, DAMAGE_TYPE_PURE, self.bonus_pure_damage, self.key)
	end

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyStrength(self.bonus_all_stats)
			hParent:ModifyAgility(self.bonus_all_stats)
			hParent:ModifyIntellect(self.bonus_all_stats)
		end
	end
end
function modifier_item_holy_cape:OnDestroy()
	local hParent = self:GetParent()
	local holy_cape_table = Load(hParent, "holy_cape_table") or {}

	local bEffective = holy_cape_table[1] == self

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyStrength(-self.bonus_all_stats)
			hParent:ModifyAgility(-self.bonus_all_stats)
			hParent:ModifyIntellect(-self.bonus_all_stats)
		end
	end

	for index = #holy_cape_table, 1, -1 do
		if holy_cape_table[index] == self then
			table.remove(holy_cape_table, index)
		end
	end
	Save(hParent, "holy_cape_table", holy_cape_table)

	if self.key ~= nil then
		SetOutgoingDamagePercent(hParent, DAMAGE_TYPE_PURE, nil, self.key)
		if holy_cape_table[1] ~= nil then
			holy_cape_table[1].key = SetOutgoingDamagePercent(hParent, DAMAGE_TYPE_PURE, holy_cape_table[1].bonus_pure_damage)
		end
	end

	if bEffective then
		local modifier = holy_cape_table[1]
		if modifier then
			if IsServer() then
				modifier:StartIntervalThink(modifier:GetAbility():GetCooldownTimeRemaining())
			end
		end
	end

	RemoveModifierEvents(MODIFIER_EVENT_ON_TAKEDAMAGE, self)
end
function modifier_item_holy_cape:OnIntervalThink()
	if IsServer() then
		local hCaster = self:GetParent()
		local hAbility = self:GetAbility()
		if not IsValid(hCaster) and not IsValid(hAbility) then
			self:Destroy()
			return
		end

		if hCaster:GetUnitLabel() == "builder" or hCaster:IsIllusion() then
			self:StartIntervalThink(-1)
			return
		end

		if hAbility:IsCooldownReady() and self.fTotalDamage >= self.threshold_value then
			local iTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
			local iType = DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC
			local iFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
			local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, self.radius, iTeam, iType, iFlags, FIND_CLOSEST, false)
			if #tTargets > 0 then
				local iParticleID = ParticleManager:CreateParticle("particles/items_fx/holy_cape.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
				ParticleManager:ReleaseParticleIndex(iParticleID)

				hCaster:EmitSound("Hero_Chen.DivineFavor.Cast")

				self.bCanNotTrigger = true
				for _, hTarget in pairs(tTargets) do
					local tDamageTable = {
						ability = hAbility,
						attacker = hCaster,
						victim = hTarget,
						damage = self.threshold_value,
						damage_type = DAMAGE_TYPE_PURE
					}
					ApplyDamage(tDamageTable)
				end
				self.bCanNotTrigger = false

				self.fTotalDamage = 0
				hAbility:SetCurrentCharges(0)

				hAbility:UseResources(true, true, true)
			end
		end
		self:StartIntervalThink(hAbility:GetCooldownTimeRemaining())
	end
end
function modifier_item_holy_cape:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		-- MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end
function modifier_item_holy_cape:GetModifierBonusStats_Strength(params)
	return self.bonus_all_stats
end
function modifier_item_holy_cape:GetModifierBonusStats_Agility(params)
	return self.bonus_all_stats
end
function modifier_item_holy_cape:GetModifierBonusStats_Intellect(params)
	return self.bonus_all_stats
end
function modifier_item_holy_cape:OnTakeDamage(params)
	local holy_cape_table = Load(self:GetParent(), "holy_cape_table") or {}
	if not self.bCanNotTrigger and holy_cape_table[1] == self and params.attacker == self:GetParent() and IsValid(params.unit) and not params.unit:IsIllusion() then
		if params.damage_type == DAMAGE_TYPE_PURE then
			self.fTotalDamage = self.fTotalDamage + params.damage
			self:GetAbility():SetCurrentCharges(math.floor(math.min(self.fTotalDamage, self.threshold_value)))
		end
	end
end