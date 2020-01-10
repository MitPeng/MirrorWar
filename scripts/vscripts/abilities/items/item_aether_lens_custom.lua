LinkLuaModifier("modifier_item_aether_lens_custom", "abilities/items/item_aether_lens_custom.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_aether_lens_custom == nil then
	item_aether_lens_custom = class({})
end
function item_aether_lens_custom:GetIntrinsicModifierName()
	return "modifier_item_aether_lens_custom"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_aether_lens_custom == nil then
	modifier_item_aether_lens_custom = class({})
end
function modifier_item_aether_lens_custom:IsHidden()
	return true
end
function modifier_item_aether_lens_custom:IsDebuff()
	return false
end
function modifier_item_aether_lens_custom:IsPurgable()
	return false
end
function modifier_item_aether_lens_custom:IsPurgeException()
	return false
end
function modifier_item_aether_lens_custom:IsStunDebuff()
	return false
end
function modifier_item_aether_lens_custom:AllowIllusionDuplicate()
	return false
end
function modifier_item_aether_lens_custom:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_item_aether_lens_custom:OnCreated(params)
	local hParent = self:GetParent()

	self.bonus_mana = self:GetAbilitySpecialValueFor("bonus_mana")
	self.bonus_mana_regen_pct = self:GetAbilitySpecialValueFor("bonus_mana_regen_pct")
	self.cast_range_bonus = self:GetAbilitySpecialValueFor("cast_range_bonus")

	local aether_lens_table = Load(hParent, "aether_lens_table") or {}
	table.insert(aether_lens_table, self)
	Save(hParent, "aether_lens_table", aether_lens_table)

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyMaxMana(self.bonus_mana)
		end
	end
end
function modifier_item_aether_lens_custom:OnRefresh(params)
	local hParent = self:GetParent()
	local aether_lens_table = Load(hParent, "aether_lens_table") or {}

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyMaxMana(-self.bonus_mana)
		end
	end

	self.bonus_mana = self:GetAbilitySpecialValueFor("bonus_mana")
	self.bonus_mana_regen_pct = self:GetAbilitySpecialValueFor("bonus_mana_regen_pct")
	self.cast_range_bonus = self:GetAbilitySpecialValueFor("cast_range_bonus")

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyMaxMana(self.bonus_mana)
		end
	end
end
function modifier_item_aether_lens_custom:OnDestroy()
	local hParent = self:GetParent()
	local aether_lens_table = Load(hParent, "aether_lens_table") or {}

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyMaxMana(-self.bonus_mana)
		end
	end

	for index = #aether_lens_table, 1, -1 do
		if aether_lens_table[index] == self then
			table.remove(aether_lens_table, index)
		end
	end
	Save(hParent, "aether_lens_table", aether_lens_table)
end
function modifier_item_aether_lens_custom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
	}
end
function modifier_item_aether_lens_custom:GetModifierManaBonus(params)
	return self.bonus_mana
end
function modifier_item_aether_lens_custom:GetModifierMPRegenAmplify_Percentage(params)
	return self.bonus_mana_regen_pct
end
function modifier_item_aether_lens_custom:GetModifierCastRangeBonusStacking(params)
	local aether_lens_table = Load(self:GetParent(), "aether_lens_table") or {}
	local ring_of_aghanim_table = Load(self:GetParent(), "ring_of_aghanim_table") or {}
	if #ring_of_aghanim_table == 0 and aether_lens_table[1] == self then
		if IsValid(params.ability) and bit.band(params.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_ATTACK) ~= DOTA_ABILITY_BEHAVIOR_ATTACK and (bit.band(params.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET or bit.band(params.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_POINT) == DOTA_ABILITY_BEHAVIOR_POINT or bit.band(params.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_OPTIONAL_UNIT_TARGET) == DOTA_ABILITY_BEHAVIOR_OPTIONAL_UNIT_TARGET or bit.band(params.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_OPTIONAL_POINT) == DOTA_ABILITY_BEHAVIOR_OPTIONAL_POINT or bit.band(params.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_RUNE_TARGET) == DOTA_ABILITY_BEHAVIOR_RUNE_TARGET or bit.band(params.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_VECTOR_TARGETING) == DOTA_ABILITY_BEHAVIOR_VECTOR_TARGETING) then
			return self.cast_range_bonus
		elseif not IsValid(params.ability) then
			return self.cast_range_bonus
		end
	end
	return 0
end
