LinkLuaModifier("modifier_item_diffusal_blade_custom", "abilities/items/item_diffusal_blade_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_diffusal_blade_custom_diffusal", "abilities/items/item_diffusal_blade_custom.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if item_diffusal_blade_custom == nil then
	item_diffusal_blade_custom = class({})
end
function item_diffusal_blade_custom:GetIntrinsicModifierName()
	return "modifier_item_diffusal_blade_custom"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_diffusal_blade_custom == nil then
	modifier_item_diffusal_blade_custom = class({})
end
function modifier_item_diffusal_blade_custom:IsHidden()
	return true
end
function modifier_item_diffusal_blade_custom:IsDebuff()
	return false
end
function modifier_item_diffusal_blade_custom:IsPurgable()
	return false
end
function modifier_item_diffusal_blade_custom:IsPurgeException()
	return false
end
function modifier_item_diffusal_blade_custom:IsStunDebuff()
	return false
end
function modifier_item_diffusal_blade_custom:AllowIllusionDuplicate()
	return false
end
function modifier_item_diffusal_blade_custom:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_item_diffusal_blade_custom:OnCreated(params)
	local hParent = self:GetParent()

	self.bonus_agility = self:GetAbilitySpecialValueFor("bonus_agility")
	self.bonus_intellect = self:GetAbilitySpecialValueFor("bonus_intellect")
	self.feedback_mana_burn = self:GetAbilitySpecialValueFor("feedback_mana_burn")
	self.feedback_mana_burn_illusion_melee = self:GetAbilitySpecialValueFor("feedback_mana_burn_illusion_melee")
	self.feedback_mana_burn_illusion_ranged = self:GetAbilitySpecialValueFor("feedback_mana_burn_illusion_ranged")
	self.damage_per_burn = self:GetAbilitySpecialValueFor("damage_per_burn")
	self.diffusal_duration = self:GetAbilitySpecialValueFor("diffusal_duration")
	local diffusal_blade_table = Load(hParent, "diffusal_blade_table") or {}
	table.insert(diffusal_blade_table, self)
	Save(hParent, "diffusal_blade_table", diffusal_blade_table)

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyAgility(self.bonus_agility) 
			hParent:ModifyIntellect(self.bonus_intellect)
		end
	end
end
function modifier_item_diffusal_blade_custom:OnRefresh(params)
	local hParent = self:GetParent()

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyAgility(-self.bonus_agility) 
			hParent:ModifyIntellect(-self.bonus_intellect)
		end
	end

	self.bonus_agility = self:GetAbilitySpecialValueFor("bonus_agility")
	self.bonus_intellect = self:GetAbilitySpecialValueFor("bonus_intellect")
	self.feedback_mana_burn = self:GetAbilitySpecialValueFor("feedback_mana_burn")
	self.feedback_mana_burn_illusion_melee = self:GetAbilitySpecialValueFor("feedback_mana_burn_illusion_melee")
	self.feedback_mana_burn_illusion_ranged = self:GetAbilitySpecialValueFor("feedback_mana_burn_illusion_ranged")
	self.damage_per_burn = self:GetAbilitySpecialValueFor("damage_per_burn")
	self.diffusal_duration = self:GetAbilitySpecialValueFor("diffusal_duration")

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyAgility(self.bonus_agility) 
			hParent:ModifyIntellect(self.bonus_intellect)
		end
	end
end
function modifier_item_diffusal_blade_custom:OnDestroy()
	local hParent = self:GetParent()

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyAgility(-self.bonus_agility) 
			hParent:ModifyIntellect(-self.bonus_intellect)
		end
	end

	local diffusal_blade_table = Load(hParent, "diffusal_blade_table") or {}
	for index = #diffusal_blade_table, 1, -1 do
		if diffusal_blade_table[index] == self then
			table.remove(diffusal_blade_table, index)
		end
	end
	Save(hParent, "diffusal_blade_table", diffusal_blade_table)
end
function modifier_item_diffusal_blade_custom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
end
function modifier_item_diffusal_blade_custom:GetModifierBonusStats_Agility(params)
	return self.bonus_agility
end
function modifier_item_diffusal_blade_custom:GetModifierBonusStats_Intellect(params)
	return self.bonus_intellect
end
function modifier_item_diffusal_blade_custom:GetModifierProcAttack_Feedback(params)
	local hCaster = params.attacker
	local hTarget = params.target
	local diffusal_blade_table = Load(self:GetParent(), "diffusal_blade_table") or {}
	local jasper_daggers_table = Load(self:GetParent(), "jasper_daggers_table") or {}
	if #jasper_daggers_table == 0 and diffusal_blade_table[1] == self and not hCaster:AttackFilter(params.record, ATTACK_STATE_NOT_PROCESSPROCS) and UnitFilter(hTarget, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_MANA_ONLY, hCaster:GetTeamNumber()) == UF_SUCCESS then
		local burn_mana = self.feedback_mana_burn
		if hCaster:IsIllusion() then
			burn_mana = hCaster:IsRangedAttacker() and self.feedback_mana_burn_illusion_ranged or self.feedback_mana_burn_illusion_melee
		end
		local total_burn_mana = math.min(burn_mana, hTarget:GetMana())
		local fDamage = total_burn_mana*self.damage_per_burn

		hTarget:ReduceMana(total_burn_mana)

		local iParticleID = ParticleManager:CreateParticle("particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
		ParticleManager:ReleaseParticleIndex(iParticleID)
		
		if hTarget:GetMana() == 0 and not hTarget:HasModifier("modifier_item_diffusal_blade_custom_diffusal") and not hTarget:HasModifier("modifier_item_jasper_daggers_diffusal") then
			hTarget:AddNewModifier(hCaster, self:GetAbility(), "modifier_item_diffusal_blade_custom_diffusal", {duration = self.diffusal_duration * hTarget:GetStatusResistanceFactor()})
		end

		return fDamage
	end
	return 0
end
---------------------------------------------------------------------
if modifier_item_diffusal_blade_custom_diffusal == nil then
	modifier_item_diffusal_blade_custom_diffusal = class({})
end
function modifier_item_diffusal_blade_custom_diffusal:IsHidden()
	return false
end
function modifier_item_diffusal_blade_custom_diffusal:IsDebuff()
	return true
end
function modifier_item_diffusal_blade_custom_diffusal:IsPurgable()
	return true
end
function modifier_item_diffusal_blade_custom_diffusal:IsPurgeException()
	return true
end
function modifier_item_diffusal_blade_custom_diffusal:IsStunDebuff()
	return false
end
function modifier_item_diffusal_blade_custom_diffusal:AllowIllusionDuplicate()
	return false
end
function modifier_item_diffusal_blade_custom_diffusal:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_item_diffusal_blade_custom_diffusal:OnCreated(params)
	local hParent = self:GetParent()
	self.diffusal_movespeed_bonus = self:GetAbilitySpecialValueFor("diffusal_movespeed_bonus")
	self.total_duraiton = self:GetDuration()
	local nIndexFX = ParticleManager:CreateParticle("particles/items_fx/diffusal_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	self:AddParticle(nIndexFX, false, false, -1, false, false)
end
function modifier_item_diffusal_blade_custom_diffusal:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end
function modifier_item_diffusal_blade_custom_diffusal:GetModifierMoveSpeedBonus_Percentage()
	return self.diffusal_movespeed_bonus * (self:GetRemainingTime() / self.total_duraiton)
end