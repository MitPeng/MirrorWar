LinkLuaModifier("modifier_item_ring_of_aghanim", "abilities/items/item_ring_of_aghanim.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_ring_of_aghanim_aura", "abilities/items/item_ring_of_aghanim.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_ring_of_aghanim_thinker", "abilities/items/item_ring_of_aghanim.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_ring_of_aghanim_effect", "abilities/items/item_ring_of_aghanim.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_ring_of_aghanim == nil then
	item_ring_of_aghanim = class({})
end
function item_ring_of_aghanim:GetIntrinsicModifierName()
	return "modifier_item_ring_of_aghanim"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_ring_of_aghanim == nil then
	modifier_item_ring_of_aghanim = class({})
end
function modifier_item_ring_of_aghanim:IsHidden()
	return true
end
function modifier_item_ring_of_aghanim:IsDebuff()
	return false
end
function modifier_item_ring_of_aghanim:IsPurgable()
	return false
end
function modifier_item_ring_of_aghanim:IsPurgeException()
	return false
end
function modifier_item_ring_of_aghanim:IsStunDebuff()
	return false
end
function modifier_item_ring_of_aghanim:AllowIllusionDuplicate()
	return false
end
function modifier_item_ring_of_aghanim:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_item_ring_of_aghanim:IsAura()
	return not self:GetParent():IsIllusion() and self:GetParent():GetUnitLabel() ~= "builder"
end
function modifier_item_ring_of_aghanim:GetModifierAura()
	return "modifier_item_ring_of_aghanim_aura"
end
function modifier_item_ring_of_aghanim:GetAuraRadius()
	return self.aura_radius
end
function modifier_item_ring_of_aghanim:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_item_ring_of_aghanim:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
end
function modifier_item_ring_of_aghanim:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end
function modifier_item_ring_of_aghanim:OnCreated(params)
	local hParent = self:GetParent()

	self.bonus_strength = self:GetAbilitySpecialValueFor("bonus_strength")
	self.bonus_agility = self:GetAbilitySpecialValueFor("bonus_agility")
	self.bonus_intellect = self:GetAbilitySpecialValueFor("bonus_intellect")
	self.bonus_mana_regen = self:GetAbilitySpecialValueFor("bonus_mana_regen")
	self.bonus_mana = self:GetAbilitySpecialValueFor("bonus_mana")
	self.aura_radius = self:GetAbilitySpecialValueFor("aura_radius")
	self.spell_amp = self:GetAbilitySpecialValueFor("spell_amp")
	self.area_duration = self:GetAbilitySpecialValueFor("area_duration")
	self.cast_range_bonus = self:GetAbilitySpecialValueFor("cast_range_bonus")
	self.multi_spell_chance = self:GetAbilitySpecialValueFor("multi_spell_chance")
	self.multi_spell_radius = self:GetAbilitySpecialValueFor("multi_spell_radius")

	local ring_of_aghanim_table = Load(hParent, "ring_of_aghanim_table") or {}
	table.insert(ring_of_aghanim_table, self)
	Save(hParent, "ring_of_aghanim_table", ring_of_aghanim_table)

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyStrength(self.bonus_strength)
			hParent:ModifyAgility(self.bonus_agility)
			hParent:ModifyIntellect(self.bonus_intellect)
			hParent:ModifyMaxMana(self.bonus_mana)
		end
	end

	AddModifierEvents(MODIFIER_EVENT_ON_SPELL_TARGET_READY, self)
end
function modifier_item_ring_of_aghanim:OnRefresh(params)
	local hParent = self:GetParent()
	local ring_of_aghanim_table = Load(hParent, "ring_of_aghanim_table") or {}

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyStrength(-self.bonus_strength)
			hParent:ModifyAgility(-self.bonus_agility)
			hParent:ModifyIntellect(-self.bonus_intellect)
			hParent:ModifyMaxMana(-self.bonus_mana)
		end
	end

	self.bonus_strength = self:GetAbilitySpecialValueFor("bonus_strength")
	self.bonus_agility = self:GetAbilitySpecialValueFor("bonus_agility")
	self.bonus_intellect = self:GetAbilitySpecialValueFor("bonus_intellect")
	self.bonus_mana_regen = self:GetAbilitySpecialValueFor("bonus_mana_regen")
	self.bonus_mana = self:GetAbilitySpecialValueFor("bonus_mana")
	self.aura_radius = self:GetAbilitySpecialValueFor("aura_radius")
	self.spell_amp = self:GetAbilitySpecialValueFor("spell_amp")
	self.area_duration = self:GetAbilitySpecialValueFor("area_duration")
	self.cast_range_bonus = self:GetAbilitySpecialValueFor("cast_range_bonus")
	self.multi_spell_chance = self:GetAbilitySpecialValueFor("multi_spell_chance")
	self.multi_spell_radius = self:GetAbilitySpecialValueFor("multi_spell_radius")

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyStrength(self.bonus_strength)
			hParent:ModifyAgility(self.bonus_agility)
			hParent:ModifyIntellect(self.bonus_intellect)
			hParent:ModifyMaxMana(self.bonus_mana)
		end
	end
end
function modifier_item_ring_of_aghanim:OnDestroy()
	local hParent = self:GetParent()
	local ring_of_aghanim_table = Load(hParent, "ring_of_aghanim_table") or {}

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyStrength(-self.bonus_strength)
			hParent:ModifyAgility(-self.bonus_agility)
			hParent:ModifyIntellect(-self.bonus_intellect)
			hParent:ModifyMaxMana(-self.bonus_mana)
		end
	end
	
	for index = #ring_of_aghanim_table, 1, -1 do
		if ring_of_aghanim_table[index] == self then
			table.remove(ring_of_aghanim_table, index)
		end
	end
	Save(hParent, "ring_of_aghanim_table", ring_of_aghanim_table)

	RemoveModifierEvents(MODIFIER_EVENT_ON_SPELL_TARGET_READY, self)
end
function modifier_item_ring_of_aghanim:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		-- MODIFIER_EVENT_ON_SPELL_TARGET_READY,
	}
end
function modifier_item_ring_of_aghanim:GetModifierBonusStats_Strength(params)
	return self.bonus_strength
end
function modifier_item_ring_of_aghanim:GetModifierBonusStats_Agility(params)
	return self.bonus_agility
end
function modifier_item_ring_of_aghanim:GetModifierBonusStats_Intellect(params)
	return self.bonus_intellect
end
function modifier_item_ring_of_aghanim:GetModifierMPRegenAmplify_Percentage(params)
	return self.bonus_mana_regen
end
function modifier_item_ring_of_aghanim:GetModifierManaBonus(params)
	return self.bonus_mana
end
function modifier_item_ring_of_aghanim:GetModifierSpellAmplify_Percentage(params)
	return self.spell_amp
end
function modifier_item_ring_of_aghanim:GetModifierCastRangeBonusStacking(params)
	local ring_of_aghanim_table = Load(self:GetParent(), "ring_of_aghanim_table") or {}
	if ring_of_aghanim_table[1] == self then
		if IsValid(params.ability) and bit.band(params.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_ATTACK) ~= DOTA_ABILITY_BEHAVIOR_ATTACK and (bit.band(params.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET or bit.band(params.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_POINT) == DOTA_ABILITY_BEHAVIOR_POINT or bit.band(params.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_OPTIONAL_UNIT_TARGET) == DOTA_ABILITY_BEHAVIOR_OPTIONAL_UNIT_TARGET or bit.band(params.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_OPTIONAL_POINT) == DOTA_ABILITY_BEHAVIOR_OPTIONAL_POINT or bit.band(params.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_RUNE_TARGET) == DOTA_ABILITY_BEHAVIOR_RUNE_TARGET or bit.band(params.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_VECTOR_TARGETING) == DOTA_ABILITY_BEHAVIOR_VECTOR_TARGETING) then
			return self.cast_range_bonus
		elseif not IsValid(params.ability) then
			return self.cast_range_bonus
		end
	end
	return 0
end
function modifier_item_ring_of_aghanim:OnSpellTargetReady(params)
	local ring_of_aghanim_table = Load(self:GetParent(), "ring_of_aghanim_table") or {}
	if ring_of_aghanim_table[1] == self and self:GetAbility():IsCooldownReady() and params.unit == self:GetParent() and params.unit:GetTeamNumber() ~= params.target:GetTeamNumber() then
		local hCaster = params.unit
		local hAbility = params.ability
		local hTarget = params.target

		if PRD(hCaster, self.multi_spell_chance, "ring_of_aghanim") then
			self:GetAbility():UseResources(true, true, true)

			local fRange = hAbility:GetCastRange(hTarget:GetAbsOrigin(), hTarget) + hCaster:GetCastRangeBonus()

			local iParticleID = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf", hCaster), PATTACH_OVERHEAD_FOLLOW, hCaster)
			ParticleManager:SetParticleControl(iParticleID, 1, Vector(2, 1, 0))
			ParticleManager:ReleaseParticleIndex(iParticleID)

			hCaster:EmitSound("Hero_OgreMagi.Fireblast.x1")

			local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, fRange+self.multi_spell_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags()+DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE+DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false)
			local hRecordTarget = hCaster:GetCursorCastTarget()
			for n, hUnit in pairs(tTargets) do
				if hUnit ~= hTarget then
					hCaster:SetCursorCastTarget(hUnit)
					hAbility:OnSpellStart()
					break
				end
			end
			hCaster:SetCursorCastTarget(hRecordTarget)
		end
	end
end
---------------------------------------------------------------------
if modifier_item_ring_of_aghanim_aura == nil then
	modifier_item_ring_of_aghanim_aura = class({})
end
function modifier_item_ring_of_aghanim_aura:IsHidden()
	return false
end
function modifier_item_ring_of_aghanim_aura:IsDebuff()
	return false
end
function modifier_item_ring_of_aghanim_aura:IsPurgable()
	return false
end
function modifier_item_ring_of_aghanim_aura:IsPurgeException()
	return false
end
function modifier_item_ring_of_aghanim_aura:IsStunDebuff()
	return false
end
function modifier_item_ring_of_aghanim_aura:AllowIllusionDuplicate()
	return false
end
function modifier_item_ring_of_aghanim_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function modifier_item_ring_of_aghanim_aura:OnCreated(params)
	self.aura_mana_regen = self:GetAbilitySpecialValueFor("aura_mana_regen")
end
function modifier_item_ring_of_aghanim_aura:OnRefresh(params)
	self.aura_mana_regen = self:GetAbilitySpecialValueFor("aura_mana_regen")
end
function modifier_item_ring_of_aghanim_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT_UNIQUE,
	}
end
function modifier_item_ring_of_aghanim_aura:GetModifierConstantManaRegenUnique(params)
	return self.aura_mana_regen
end