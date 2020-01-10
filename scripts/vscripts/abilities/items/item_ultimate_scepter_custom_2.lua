LinkLuaModifier("modifier_item_ultimate_scepter_custom_2", "abilities/items/item_ultimate_scepter_custom_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_ultimate_scepter_custom_2_effect", "abilities/items/item_ultimate_scepter_custom_2.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if item_ultimate_scepter_custom_2 == nil then
	item_ultimate_scepter_custom_2 = class({})
end
function item_ultimate_scepter_custom_2:CastFilterResult()
	if not self:GetCaster():HasModifier("modifier_building") then
		self.error = "dota_hud_error_only_building_can_use"
		return UF_FAIL_CUSTOM
	end
	if self:GetCaster():HasModifier("modifier_item_ultimate_scepter_custom_2_effect") then
		self.error = "dota_hud_error_cant_cast_scepter_buff"
		return UF_FAIL_CUSTOM
	end
	return UF_SUCCESS
end
function item_ultimate_scepter_custom_2:GetCustomCastError()
	return self.error
end
function item_ultimate_scepter_custom_2:OnSpellStart()
	local hCaster = self:GetCaster()

	hCaster:AddNewModifier(hCaster, self, "modifier_item_ultimate_scepter_custom_2_effect", nil)

	self:RemoveSelf()
end
function item_ultimate_scepter_custom_2:ProcsMagicStick()
	return false
end
function item_ultimate_scepter_custom_2:GetIntrinsicModifierName()
	return "modifier_item_ultimate_scepter_custom_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_ultimate_scepter_custom_2 == nil then
	modifier_item_ultimate_scepter_custom_2 = class({})
end
function modifier_item_ultimate_scepter_custom_2:IsHidden()
	return true
end
function modifier_item_ultimate_scepter_custom_2:IsDebuff()
	return false
end
function modifier_item_ultimate_scepter_custom_2:IsPurgable()
	return false
end
function modifier_item_ultimate_scepter_custom_2:IsPurgeException()
	return false
end
function modifier_item_ultimate_scepter_custom_2:IsStunDebuff()
	return false
end
function modifier_item_ultimate_scepter_custom_2:AllowIllusionDuplicate()
	return false
end
function modifier_item_ultimate_scepter_custom_2:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_item_ultimate_scepter_custom_2:OnCreated(params)
	local hParent = self:GetParent()

	self.bonus_all_stats = self:GetAbilitySpecialValueFor("bonus_all_stats")
	self.bonus_health = self:GetAbilitySpecialValueFor("bonus_health")
	self.bonus_mana = self:GetAbilitySpecialValueFor("bonus_mana")

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyStrength(self.bonus_all_stats)
			hParent:ModifyAgility(self.bonus_all_stats)
			hParent:ModifyIntellect(self.bonus_all_stats)
			hParent:ModifyMaxHealth(self.bonus_health)
			hParent:ModifyMaxMana(self.bonus_mana)
		end
	end
end
function modifier_item_ultimate_scepter_custom_2:OnRefresh(params)
	local hParent = self:GetParent()

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyStrength(-self.bonus_all_stats)
			hParent:ModifyAgility(-self.bonus_all_stats)
			hParent:ModifyIntellect(-self.bonus_all_stats)
			hParent:ModifyMaxHealth(-self.bonus_health)
			hParent:ModifyMaxMana(-self.bonus_mana)
		end
	end

	self.bonus_all_stats = self:GetAbilitySpecialValueFor("bonus_all_stats")
	self.bonus_health = self:GetAbilitySpecialValueFor("bonus_health")
	self.bonus_mana = self:GetAbilitySpecialValueFor("bonus_mana")

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyStrength(self.bonus_all_stats)
			hParent:ModifyAgility(self.bonus_all_stats)
			hParent:ModifyIntellect(self.bonus_all_stats)
			hParent:ModifyMaxHealth(self.bonus_health)
			hParent:ModifyMaxMana(self.bonus_mana)
		end
	end
end
function modifier_item_ultimate_scepter_custom_2:OnDestroy()
	local hParent = self:GetParent()

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyStrength(-self.bonus_all_stats)
			hParent:ModifyAgility(-self.bonus_all_stats)
			hParent:ModifyIntellect(-self.bonus_all_stats)
			hParent:ModifyMaxHealth(-self.bonus_health)
			hParent:ModifyMaxMana(-self.bonus_mana)
		end
	end
end
function modifier_item_ultimate_scepter_custom_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_IS_SCEPTER,
	}
end
function modifier_item_ultimate_scepter_custom_2:GetModifierBonusStats_Strength(params)
	return self.bonus_all_stats
end
function modifier_item_ultimate_scepter_custom_2:GetModifierBonusStats_Agility(params)
	return self.bonus_all_stats
end
function modifier_item_ultimate_scepter_custom_2:GetModifierBonusStats_Intellect(params)
	return self.bonus_all_stats
end
function modifier_item_ultimate_scepter_custom_2:GetModifierHealthBonus(params)
	return self.bonus_health
end
function modifier_item_ultimate_scepter_custom_2:GetModifierScepter(params)
	return 1
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_ultimate_scepter_custom_2_effect == nil then
	modifier_item_ultimate_scepter_custom_2_effect = class({})
end
function modifier_item_ultimate_scepter_custom_2_effect:IsHidden()
	return false
end
function modifier_item_ultimate_scepter_custom_2_effect:IsDebuff()
	return false
end
function modifier_item_ultimate_scepter_custom_2_effect:IsPurgable()
	return false
end
function modifier_item_ultimate_scepter_custom_2_effect:IsPurgeException()
	return false
end
function modifier_item_ultimate_scepter_custom_2_effect:IsStunDebuff()
	return false
end
function modifier_item_ultimate_scepter_custom_2_effect:AllowIllusionDuplicate()
	return true
end
function modifier_item_ultimate_scepter_custom_2_effect:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_item_ultimate_scepter_custom_2_effect:GetTexture()
	return "item_ultimate_scepter"
end 
function modifier_item_ultimate_scepter_custom_2_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_IS_SCEPTER,
	}
end
function modifier_item_ultimate_scepter_custom_2_effect:GetModifierScepter(params)
	return 1
end