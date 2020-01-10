LinkLuaModifier("modifier_item_quelling_blade_custom", "abilities/items/item_quelling_blade_custom.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_quelling_blade_custom == nil then
	item_quelling_blade_custom = class({})
end
function item_quelling_blade_custom:GetIntrinsicModifierName()
	return "modifier_item_quelling_blade_custom"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_quelling_blade_custom == nil then
	modifier_item_quelling_blade_custom = class({})
end
function modifier_item_quelling_blade_custom:IsHidden()
	return true
end
function modifier_item_quelling_blade_custom:IsDebuff()
	return false
end
function modifier_item_quelling_blade_custom:IsPurgable()
	return false
end
function modifier_item_quelling_blade_custom:IsPurgeException()
	return false
end
function modifier_item_quelling_blade_custom:IsStunDebuff()
	return false
end
function modifier_item_quelling_blade_custom:AllowIllusionDuplicate()
	return false
end
function modifier_item_quelling_blade_custom:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_item_quelling_blade_custom:OnCreated(params)
	local hParent = self:GetParent()
	self.damage_bonus = self:GetAbilitySpecialValueFor("damage_bonus")
	self.damage_bonus_ranged = self:GetAbilitySpecialValueFor("damage_bonus_ranged")
	local quelling_blade_table = Load(hParent, "quelling_blade_table") or {}
	table.insert(quelling_blade_table, self)
	Save(hParent, "quelling_blade_table", quelling_blade_table)
end
function modifier_item_quelling_blade_custom:OnRefresh(params)
	local hParent = self:GetParent()
	self.damage_bonus = self:GetAbilitySpecialValueFor("damage_bonus")
	self.damage_bonus_ranged = self:GetAbilitySpecialValueFor("damage_bonus_ranged")
end
function modifier_item_quelling_blade_custom:OnDestroy()
	local hParent = self:GetParent()

	local quelling_blade_table = Load(hParent, "quelling_blade_table") or {}
	for index = #quelling_blade_table, 1, -1 do
		if quelling_blade_table[index] == self then
			table.remove(quelling_blade_table, index)
		end
	end
	Save(hParent, "quelling_blade_table", quelling_blade_table)
end
function modifier_item_quelling_blade_custom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
end
function modifier_item_quelling_blade_custom:GetModifierPreAttack_BonusDamage(params)
	if IsServer() then
		if params.target == nil or params.target:GetClassname() == "dota_item_drop" then return end

		local blade_of_the_vigil_table = Load(self:GetParent(), "blade_of_the_vigil_table") or {}
		local quelling_blade_table = Load(self:GetParent(), "quelling_blade_table") or {}
		local bfury_table = Load(self:GetParent(), "bfury_table") or {}
		if #blade_of_the_vigil_table == 0 and #bfury_table == 0 and quelling_blade_table[1] == self then
			if not params.attacker:AttackFilter(params.record, ATTACK_STATE_NOT_PROCESSPROCS) and UnitFilter(params.target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, params.attacker:GetTeamNumber()) == UF_SUCCESS then
				if params.attacker:IsRangedAttacker() then
					return self.damage_bonus_ranged
				end
				return self.damage_bonus
			end
		end
	end
end