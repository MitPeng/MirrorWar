LinkLuaModifier("modifier_item_cloak_of_endless_carnage", "abilities/items/item_cloak_of_endless_carnage.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_cloak_of_endless_carnage == nil then
	item_cloak_of_endless_carnage = class({})
end
function item_cloak_of_endless_carnage:RefreshCharges()
	local hCaster = self:GetCaster()
	local hModifier = hCaster:FindModifierByName(self:GetIntrinsicModifierName())
	if IsValid(hModifier) then
		hModifier:StartIntervalThink(math.max(self:GetCooldownTimeRemaining(), 1))
	end
end
function item_cloak_of_endless_carnage:GetIntrinsicModifierName()
	return "modifier_item_cloak_of_endless_carnage"
end
-- ---------------------------------------------------------------------
-- if item_cloak_of_endless_carnage_2 == nil then
-- 	item_cloak_of_endless_carnage_2 = class({})
-- end
-- function item_cloak_of_endless_carnage_2:GetIntrinsicModifierName()
-- 	return "modifier_item_cloak_of_endless_carnage"
-- end
-- ---------------------------------------------------------------------
-- if item_cloak_of_endless_carnage_3 == nil then
-- 	item_cloak_of_endless_carnage_3 = class({})
-- end
-- function item_cloak_of_endless_carnage_3:GetIntrinsicModifierName()
-- 	return "modifier_item_cloak_of_endless_carnage"
-- end
---------------------------------------------------------------------
--Modifiers
if modifier_item_cloak_of_endless_carnage == nil then
	modifier_item_cloak_of_endless_carnage = class({})
end
function modifier_item_cloak_of_endless_carnage:IsHidden()
	return true
end
function modifier_item_cloak_of_endless_carnage:IsDebuff()
	return false
end
function modifier_item_cloak_of_endless_carnage:IsPurgable()
	return false
end
function modifier_item_cloak_of_endless_carnage:IsPurgeException()
	return false
end
function modifier_item_cloak_of_endless_carnage:IsStunDebuff()
	return false
end
function modifier_item_cloak_of_endless_carnage:AllowIllusionDuplicate()
	return false
end
function modifier_item_cloak_of_endless_carnage:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_item_cloak_of_endless_carnage:OnCreated(params)
	local hParent = self:GetParent()

	self.bonus_intellect = self:GetAbilitySpecialValueFor("bonus_intellect")
	self.bonus_strength = self:GetAbilitySpecialValueFor("bonus_strength")
	self.bonus_agility = self:GetAbilitySpecialValueFor("bonus_agility")
	self.bonus_mana = self:GetAbilitySpecialValueFor("bonus_mana")
	self.max_charges = self:GetAbilitySpecialValueFor("max_charges")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.damage_int_multiplier = self:GetAbilitySpecialValueFor("damage_int_multiplier")
	self.damage_health_pct = self:GetAbilitySpecialValueFor("damage_health_pct")
	self.damage_health_pct_creep = self:GetAbilitySpecialValueFor("damage_health_pct_creep")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.range = self:GetAbilitySpecialValueFor("range")
	self.resist_ingore = self:GetAbilitySpecialValueFor("resist_ingore")

	local coec_table = Load(hParent, "coec_table") or {}
	table.insert(coec_table, self)
	Save(hParent, "coec_table", coec_table)

	if coec_table[1] == self then
		self.key = SetIgnoreMagicResistanceValue(hParent, self.resist_ingore*0.01)
	end

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyIntellect(self.bonus_intellect)
			hParent:ModifyStrength(self.bonus_strength)
			hParent:ModifyAgility(self.bonus_agility)
			hParent:ModifyMaxMana(self.bonus_mana)
		end

		if coec_table[1] == self then
			self:StartIntervalThink(self:GetAbility():GetCooldownTimeRemaining())
		end
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ABILITY_EXECUTED, self)
end
function modifier_item_cloak_of_endless_carnage:OnRefresh(params)
	local hParent = self:GetParent()

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyIntellect(-self.bonus_intellect)
			hParent:ModifyStrength(-self.bonus_strength)
			hParent:ModifyAgility(-self.bonus_agility)
			hParent:ModifyMaxMana(-self.bonus_mana)
		end
	end

	self.bonus_intellect = self:GetAbilitySpecialValueFor("bonus_intellect")
	self.bonus_strength = self:GetAbilitySpecialValueFor("bonus_strength")
	self.bonus_agility = self:GetAbilitySpecialValueFor("bonus_agility")
	self.bonus_mana = self:GetAbilitySpecialValueFor("bonus_mana")
	self.max_charges = self:GetAbilitySpecialValueFor("max_charges")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.damage_int_multiplier = self:GetAbilitySpecialValueFor("damage_int_multiplier")
	self.damage_health_pct = self:GetAbilitySpecialValueFor("damage_health_pct")
	self.damage_health_pct_creep = self:GetAbilitySpecialValueFor("damage_health_pct_creep")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.range = self:GetAbilitySpecialValueFor("range")
	self.resist_ingore = self:GetAbilitySpecialValueFor("resist_ingore")

	if self.key ~= nil then
		SetIgnoreMagicResistanceValue(hParent, self.resist_ingore*0.01, self.key)
	end

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyIntellect(self.bonus_intellect)
			hParent:ModifyStrength(self.bonus_strength)
			hParent:ModifyAgility(self.bonus_agility)
			hParent:ModifyMaxMana(self.bonus_mana)
		end
	end
end
function modifier_item_cloak_of_endless_carnage:OnDestroy()
	local hParent = self:GetParent()
	local coec_table = Load(hParent, "coec_table") or {}

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyIntellect(-self.bonus_intellect)
			hParent:ModifyStrength(-self.bonus_strength)
			hParent:ModifyAgility(-self.bonus_agility)
			hParent:ModifyMaxMana(-self.bonus_mana)
		end
	end

	local coec_table = Load(hParent, "coec_table") or {}
	for index = #coec_table, 1, -1 do
		if coec_table[index] == self then
			table.remove(coec_table, index)
		end
	end
	Save(hParent, "coec_table", coec_table)

	if self.key ~= nil then
		SetIgnoreMagicResistanceValue(hParent, nil, self.key)
		if coec_table[1] ~= nil then
			coec_table[1].key = SetIgnoreMagicResistanceValue(hParent, coec_table[1].resist_ingore*0.01)
		end
	end

	if bEffective then
		local modifier = coec_table[1]
		if modifier then
			if IsServer() then
				modifier:StartIntervalThink(modifier:GetAbility():GetCooldownTimeRemaining())
			end
		end
	end

	RemoveModifierEvents(MODIFIER_EVENT_ON_ABILITY_EXECUTED, self)
end
function modifier_item_cloak_of_endless_carnage:OnIntervalThink()
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

		if hAbility:IsCooldownReady() and hAbility:GetCurrentCharges() >= self.max_charges then
			local vPosition = GetMostTargetsPosition(hCaster:GetAbsOrigin(), self.range, hCaster:GetTeamNumber(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST)
			if vPosition ~= nil then
				local iIntellect = hCaster:GetIntellect()

				local iParticleID = ParticleManager:CreateParticle("particles/econ/items/centaur/centaur_ti6/centaur_ti6_warstomp.vpcf", PATTACH_WORLDORIGIN, nil)
				ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
				ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, self.radius, self.radius))
				ParticleManager:ReleaseParticleIndex(iParticleID)

				EmitSoundOnLocationWithCaster(vPosition, "Item.CloakOfEndlessCarnage.Release", hCaster)

				local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), vPosition, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
				for n, hTarget in pairs(tTargets) do
					local damage_table =
					{
						ability = ability,
						attacker = hCaster,
						victim = hTarget,
						damage = self.damage + iIntellect * self.damage_int_multiplier,
						damage_type = DAMAGE_TYPE_MAGICAL
					}
					ApplyDamage(damage_table)

					local damage_health_pct = hTarget:IsConsideredHero() and self.damage_health_pct or self.damage_health_pct_creep
					local damage_table =
					{
						ability = ability,
						attacker = hCaster,
						victim = hTarget,
						damage = hTarget:GetHealth() * damage_health_pct*0.01,
						damage_type = DAMAGE_TYPE_PURE,
						damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
					}
					ApplyDamage(damage_table)
				end

				hAbility:SetCurrentCharges(0)

				hAbility:UseResources(true, true, true)
			end
		end
		self:StartIntervalThink(hAbility:GetCooldownTimeRemaining())
	end
end
function modifier_item_cloak_of_endless_carnage:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		-- MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}
end
function modifier_item_cloak_of_endless_carnage:GetModifierBonusStats_Intellect(params)
	return self.bonus_intellect
end
function modifier_item_cloak_of_endless_carnage:GetModifierBonusStats_Intellect(params)
	return self.bonus_strength
end
function modifier_item_cloak_of_endless_carnage:GetModifierBonusStats_Intellect(params)
	return self.bonus_agility
end
function modifier_item_cloak_of_endless_carnage:OnAbilityExecuted(params)
	if params.unit ~= nil and params.unit == self:GetParent() and self:GetParent():GetUnitLabel() ~= "builder" and not params.unit:IsIllusion() then
		if params.ability == nil or params.ability:IsItem() or not params.ability:ProcsMagicStick() or not params.unit:IsAlive() then return end

		if params.unit.GetIntellect == nil then return end

		-- 智力检测
		local intellect = params.unit:GetIntellect()
		if intellect <= params.unit:GetStrength() or intellect <= params.unit:GetAgility() then return end

		local coec_table = Load(params.unit, "coec_table") or {}
		if coec_table[1] == self then -- 多个只触发一次
			-- 计数
			local ability = self:GetAbility()
			local charge = ability:GetCurrentCharges()

			charge = math.min(charge + 1, self.max_charges)

			ability:SetCurrentCharges(charge)
		end
	end
end