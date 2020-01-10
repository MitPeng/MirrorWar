LinkLuaModifier("modifier_item_yasha_and_kaya_custom", "abilities/items/item_yasha_and_kaya_custom.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_yasha_and_kaya_custom == nil then
	item_yasha_and_kaya_custom = class({})
end
function item_yasha_and_kaya_custom:GetIntrinsicModifierName()
	return "modifier_item_yasha_and_kaya_custom"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_yasha_and_kaya_custom == nil then
	modifier_item_yasha_and_kaya_custom = class({})
end
function modifier_item_yasha_and_kaya_custom:IsHidden()
	return true
end
function modifier_item_yasha_and_kaya_custom:IsDebuff()
	return false
end
function modifier_item_yasha_and_kaya_custom:IsPurgable()
	return false
end
function modifier_item_yasha_and_kaya_custom:IsPurgeException()
	return false
end
function modifier_item_yasha_and_kaya_custom:IsStunDebuff()
	return false
end
function modifier_item_yasha_and_kaya_custom:AllowIllusionDuplicate()
	return false
end
function modifier_item_yasha_and_kaya_custom:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_item_yasha_and_kaya_custom:OnCreated(params)
	local hParent = self:GetParent()

	self.bonus_agility = self:GetAbilitySpecialValueFor("bonus_agility")
	self.bonus_intellect = self:GetAbilitySpecialValueFor("bonus_intellect")
	self.bonus_attack_speed = self:GetAbilitySpecialValueFor("bonus_attack_speed")
	self.spell_amp = self:GetAbilitySpecialValueFor("spell_amp")

	if IsServer() then
		if hParent:IsBuilding() then 
			hParent:ModifyAgility(self.bonus_agility)
			hParent:ModifyIntellect(self.bonus_intellect)
		end
	end
end
function modifier_item_yasha_and_kaya_custom:OnRefresh(params)
	local hParent = self:GetParent()

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyAgility(-self.bonus_agility)
			hParent:ModifyIntellect(-self.bonus_intellect)
		end
	end

	self.bonus_agility = self:GetAbilitySpecialValueFor("bonus_agility")
	self.bonus_intellect = self:GetAbilitySpecialValueFor("bonus_intellect")
	self.bonus_attack_speed = self:GetAbilitySpecialValueFor("bonus_attack_speed")
	self.spell_amp = self:GetAbilitySpecialValueFor("spell_amp")

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyAgility(self.bonus_agility)
			hParent:ModifyIntellect(self.bonus_intellect)
		end
	end
end
function modifier_item_yasha_and_kaya_custom:OnDestroy()
	local hParent = self:GetParent()

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyAgility(-self.bonus_agility)
			hParent:ModifyIntellect(-self.bonus_intellect)
		end
	end
end
function modifier_item_yasha_and_kaya_custom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE,
	}
end
function modifier_item_yasha_and_kaya_custom:GetModifierBonusStats_Agility(params)
	return self.bonus_agility
end
function modifier_item_yasha_and_kaya_custom:GetModifierBonusStats_Intellect(params)
	return self.bonus_intellect
end
function modifier_item_yasha_and_kaya_custom:GetModifierAttackSpeedBonus_Constant(params)
	return self.bonus_attack_speed
end
function modifier_item_yasha_and_kaya_custom:GetModifierSpellAmplify_PercentageUnique(params)
	return self.spell_amp
end