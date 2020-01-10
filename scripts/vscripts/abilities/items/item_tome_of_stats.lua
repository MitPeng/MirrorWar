LinkLuaModifier("modifier_item_tome_of_stats", "abilities/items/item_tome_of_stats.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_tome_of_stats_10 == nil then
	item_tome_of_stats_10 = class({})
end
function item_tome_of_stats_10:CastFilterResultTarget(hTarget)
	if hTarget:GetUnitLabel() == "builder" then
		return UF_FAIL_OTHER
	end
	if hTarget:GetUnitLabel() ~= "HERO" then
		return UF_FAIL_CREEP
	end
	return UnitFilter(hTarget, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, self:GetCaster():GetTeamNumber())
end
function item_tome_of_stats_10:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	if target.GetBuilding ~= nil then
		target:AddNewModifier(target, self, "modifier_item_tome_of_stats", nil)

		EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Item.TomeOfKnowledge", caster)

		self:SpendCharge()
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_tome_of_stats == nil then
	modifier_item_tome_of_stats = class({})
end
function modifier_item_tome_of_stats:IsHidden()
	return false
end
function modifier_item_tome_of_stats:IsDebuff()
	return false
end
function modifier_item_tome_of_stats:IsPurgable()
	return false
end
function modifier_item_tome_of_stats:IsPurgeException()
	return false
end
function modifier_item_tome_of_stats:AllowIllusionDuplicate()
	return true
end
function modifier_item_tome_of_stats:RemoveOnDeath()
	return false
end
function modifier_item_tome_of_stats:DestroyOnExpire()
	return false
end
function modifier_item_tome_of_stats:IsPermanent()
	return true
end
function modifier_item_tome_of_stats:GetTexture()
	return "item_tome_of_stats"
end
function modifier_item_tome_of_stats:OnCreated(params)
	local hParent = self:GetParent()

	self.all_stats_bonus = self:GetAbilitySpecialValueFor("all_stats_bonus")

	if IsServer() then
		self:SetStackCount(self:GetStackCount()+self.all_stats_bonus)

		if hParent:IsBuilding() then
			hParent:ModifyStrength(self:GetStackCount())
			hParent:ModifyAgility(self:GetStackCount())
			hParent:ModifyIntellect(self:GetStackCount())
		end
	end
end
function modifier_item_tome_of_stats:OnRefresh(params)
	local hParent = self:GetParent()

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyStrength(-self:GetStackCount())
			hParent:ModifyAgility(-self:GetStackCount())
			hParent:ModifyIntellect(-self:GetStackCount())
		end
	end

	self.all_stats_bonus = self:GetAbilitySpecialValueFor("all_stats_bonus")

	if IsServer() then
		self:SetStackCount(self:GetStackCount()+self.all_stats_bonus)

		if hParent:IsBuilding() then
			hParent:ModifyStrength(self:GetStackCount())
			hParent:ModifyAgility(self:GetStackCount())
			hParent:ModifyIntellect(self:GetStackCount())
		end
	end
end
function modifier_item_tome_of_stats:OnDestroy()
	local hParent = self:GetParent()

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyStrength(-self:GetStackCount())
			hParent:ModifyAgility(-self:GetStackCount())
			hParent:ModifyIntellect(-self:GetStackCount())
		end
	end
end
function modifier_item_tome_of_stats:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_item_tome_of_stats:GetModifierBonusStats_Strength(params)
	return self:GetStackCount()
end
function modifier_item_tome_of_stats:GetModifierBonusStats_Agility(params)
	return self:GetStackCount()
end
function modifier_item_tome_of_stats:GetModifierBonusStats_Intellect(params)
	return self:GetStackCount()
end
function modifier_item_tome_of_stats:OnTooltip(params)
	return self:GetStackCount()
end