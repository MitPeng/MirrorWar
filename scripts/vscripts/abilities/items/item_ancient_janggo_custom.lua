LinkLuaModifier("modifier_item_ancient_janggo_custom", "abilities/items/item_ancient_janggo_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_ancient_janggo_custom_aura", "abilities/items/item_ancient_janggo_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_ancient_janggo_custom_activate", "abilities/items/item_ancient_janggo_custom.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if item_ancient_janggo_custom == nil then
	item_ancient_janggo_custom = class({})
end
function item_ancient_janggo_custom:CastFilterResult()
	if not self:GetCaster():HasModifier("modifier_building") then
		self.error = "dota_hud_error_only_building_can_use"
		return UF_FAIL_CUSTOM
	end
end
function item_ancient_janggo_custom:GetCustomCastError()
	return self.error
end
function item_ancient_janggo_custom:OnSpellStart()
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local activate_duration = self:GetSpecialValueFor("activate_duration")

	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
	for _, hTarget in pairs(tTargets) do
		hTarget:AddNewModifier(hCaster, self, "modifier_item_ancient_janggo_custom_activate", {duration = activate_duration})
	end

	hCaster:EmitSound("DOTA_Item.DoE.Activate")

	self:SpendCharge()
end
function item_ancient_janggo_custom:GetIntrinsicModifierName()
	return "modifier_item_ancient_janggo_custom"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_ancient_janggo_custom == nil then
	modifier_item_ancient_janggo_custom = class({})
end
function modifier_item_ancient_janggo_custom:IsHidden()
	return true
end
function modifier_item_ancient_janggo_custom:IsDebuff()
	return false
end
function modifier_item_ancient_janggo_custom:IsPurgable()
	return false
end
function modifier_item_ancient_janggo_custom:IsPurgeException()
	return false
end
function modifier_item_ancient_janggo_custom:IsStunDebuff()
	return false
end
function modifier_item_ancient_janggo_custom:AllowIllusionDuplicate()
	return false
end
function modifier_item_ancient_janggo_custom:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_item_ancient_janggo_custom:IsAura()
    return not self:GetParent():IsIllusion() and self:GetParent():GetUnitLabel() ~= "builder"
end
function modifier_item_ancient_janggo_custom:GetModifierAura()
    return "modifier_item_ancient_janggo_custom_aura"
end
function modifier_item_ancient_janggo_custom:GetAuraRadius()
    return self.radius
end
function modifier_item_ancient_janggo_custom:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_item_ancient_janggo_custom:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
end
function modifier_item_ancient_janggo_custom:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end
function modifier_item_ancient_janggo_custom:OnCreated(params)
	local hParent = self:GetParent()

	self.bonus_int = self:GetAbilitySpecialValueFor("bonus_int")
	self.bonus_str = self:GetAbilitySpecialValueFor("bonus_str")
	self.bonus_agi = self:GetAbilitySpecialValueFor("bonus_agi")
    self.bonus_mana_regen = self:GetAbilitySpecialValueFor("bonus_mana_regen")
	self.radius = self:GetAbilitySpecialValueFor("radius")

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyStrength(self.bonus_str)
			hParent:ModifyAgility(self.bonus_agi)
			hParent:ModifyIntellect(self.bonus_int)
		end
	end
end
function modifier_item_ancient_janggo_custom:OnRefresh(params)
	local hParent = self:GetParent()

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyStrength(-self.bonus_str)
			hParent:ModifyAgility(-self.bonus_agi)
			hParent:ModifyIntellect(-self.bonus_int)
		end
	end

	self.bonus_int = self:GetAbilitySpecialValueFor("bonus_int")
	self.bonus_str = self:GetAbilitySpecialValueFor("bonus_str")
	self.bonus_agi = self:GetAbilitySpecialValueFor("bonus_agi")
    self.bonus_mana_regen = self:GetAbilitySpecialValueFor("bonus_mana_regen")
	self.radius = self:GetAbilitySpecialValueFor("radius")

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyStrength(self.bonus_str)
			hParent:ModifyAgility(self.bonus_agi)
			hParent:ModifyIntellect(self.bonus_int)
		end
	end
end
function modifier_item_ancient_janggo_custom:OnDestroy()
	local hParent = self:GetParent()

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyStrength(-self.bonus_str)
			hParent:ModifyAgility(-self.bonus_agi)
			hParent:ModifyIntellect(-self.bonus_int)
		end
	end
end
function modifier_item_ancient_janggo_custom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
	}
end
function modifier_item_ancient_janggo_custom:GetModifierMPRegenAmplify_Percentage(params)
	return self.bonus_mana_regen
end
function modifier_item_ancient_janggo_custom:GetModifierBonusStats_Strength(params)
	return self.bonus_str
end
function modifier_item_ancient_janggo_custom:GetModifierBonusStats_Agility(params)
	return self.bonus_agi
end
function modifier_item_ancient_janggo_custom:GetModifierBonusStats_Intellect(params)
	return self.bonus_int
end
---------------------------------------------------------------------
if modifier_item_ancient_janggo_custom_aura == nil then
	modifier_item_ancient_janggo_custom_aura = class({})
end
function modifier_item_ancient_janggo_custom_aura:IsHidden()
	return false
end
function modifier_item_ancient_janggo_custom_aura:IsDebuff()
	return false
end
function modifier_item_ancient_janggo_custom_aura:IsPurgable()
	return false
end
function modifier_item_ancient_janggo_custom_aura:IsPurgeException()
	return false
end
function modifier_item_ancient_janggo_custom_aura:IsStunDebuff()
	return false
end
function modifier_item_ancient_janggo_custom_aura:AllowIllusionDuplicate()
	return false
end
function modifier_item_ancient_janggo_custom_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function modifier_item_ancient_janggo_custom_aura:OnCreated(params)
	self.bonus_aura_attack_speed = self:GetAbilitySpecialValueFor("bonus_aura_attack_speed")
	self.bonus_aura_damage_pct = self:GetAbilitySpecialValueFor("bonus_aura_damage_pct")
end
function modifier_item_ancient_janggo_custom_aura:OnRefresh(params)
	self.bonus_aura_attack_speed = self:GetAbilitySpecialValueFor("bonus_aura_attack_speed")
	self.bonus_aura_damage_pct = self:GetAbilitySpecialValueFor("bonus_aura_damage_pct")
end
function modifier_item_ancient_janggo_custom_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
end
function modifier_item_ancient_janggo_custom_aura:GetModifierAttackSpeedBonus_Constant(params)
	return self.bonus_aura_attack_speed
end
function modifier_item_ancient_janggo_custom_aura:GetModifierBaseDamageOutgoing_Percentage(params)
	return self.bonus_aura_damage_pct
end
---------------------------------------------------------------------
if modifier_item_ancient_janggo_custom_activate == nil then
	modifier_item_ancient_janggo_custom_activate = class({})
end
function modifier_item_ancient_janggo_custom_activate:IsHidden()
	return false
end
function modifier_item_ancient_janggo_custom_activate:IsDebuff()
	return false
end
function modifier_item_ancient_janggo_custom_activate:IsPurgable()
	return false
end
function modifier_item_ancient_janggo_custom_activate:IsPurgeException()
	return false
end
function modifier_item_ancient_janggo_custom_activate:IsStunDebuff()
	return false
end
function modifier_item_ancient_janggo_custom_activate:AllowIllusionDuplicate()
	return false
end
function modifier_item_ancient_janggo_custom_activate:GetEffectName()
	return "particles/items_fx/drum_of_endurance_buff.vpcf"
end
function modifier_item_ancient_janggo_custom_activate:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_item_ancient_janggo_custom_activate:OnCreated(params)
	self.activate_bonus_attack_speed = self:GetAbilitySpecialValueFor("activate_bonus_attack_speed")
	self.activate_bonus_damage_pct = self:GetAbilitySpecialValueFor("activate_bonus_damage_pct")
end
function modifier_item_ancient_janggo_custom_activate:OnRefresh(params)
	self.activate_bonus_attack_speed = self:GetAbilitySpecialValueFor("activate_bonus_attack_speed")
	self.activate_bonus_damage_pct = self:GetAbilitySpecialValueFor("activate_bonus_damage_pct")
end
function modifier_item_ancient_janggo_custom_activate:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
end
function modifier_item_ancient_janggo_custom_activate:GetModifierAttackSpeedBonus_Constant(params)
	return self.activate_bonus_attack_speed
end
function modifier_item_ancient_janggo_custom_activate:GetModifierBaseDamageOutgoing_Percentage(params)
	return self.activate_bonus_damage_pct
end