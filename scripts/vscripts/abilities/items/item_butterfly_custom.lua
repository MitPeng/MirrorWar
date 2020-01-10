LinkLuaModifier("modifier_item_butterfly_custom", "abilities/items/item_butterfly_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_butterfly_custom_flutter", "abilities/items/item_butterfly_custom.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if item_butterfly_custom == nil then
	item_butterfly_custom = class({})
end
function item_butterfly_custom:GetIntrinsicModifierName()
	return "modifier_item_butterfly_custom"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_butterfly_custom == nil then
	modifier_item_butterfly_custom = class({})
end
function modifier_item_butterfly_custom:IsHidden()
	return true
end
function modifier_item_butterfly_custom:IsDebuff()
	return false
end
function modifier_item_butterfly_custom:IsPurgable()
	return false
end
function modifier_item_butterfly_custom:IsPurgeException()
	return false
end
function modifier_item_butterfly_custom:IsStunDebuff()
	return false
end
function modifier_item_butterfly_custom:AllowIllusionDuplicate()
	return false
end
function modifier_item_butterfly_custom:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_item_butterfly_custom:OnCreated(params)
	local hParent = self:GetParent()

	self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
	self.bonus_agility = self:GetAbilitySpecialValueFor("bonus_agility")
	self.bonus_attack_speed = self:GetAbilitySpecialValueFor("bonus_attack_speed")
	self.flutter_chance = self:GetAbilitySpecialValueFor("flutter_chance")
	self.flutter_base_agility_factor = self:GetAbilitySpecialValueFor("flutter_base_agility_factor")
	self.flutter_duration = self:GetAbilitySpecialValueFor("flutter_duration")
	local butterfly_table = Load(hParent, "butterfly_table") or {}
	table.insert(butterfly_table, self)
	Save(hParent, "butterfly_table", butterfly_table)

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyAgility(self.bonus_agility)
		end
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_item_butterfly_custom:OnRefresh(params)
	local hParent = self:GetParent()

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyAgility(-self.bonus_agility)
		end
	end

	self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
	self.bonus_agility = self:GetAbilitySpecialValueFor("bonus_agility")
	self.bonus_attack_speed = self:GetAbilitySpecialValueFor("bonus_attack_speed")
	self.flutter_chance = self:GetAbilitySpecialValueFor("flutter_chance")
	self.flutter_base_agility_factor = self:GetAbilitySpecialValueFor("flutter_base_agility_factor")
	self.flutter_duration = self:GetAbilitySpecialValueFor("flutter_duration")

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyAgility(self.bonus_agility)
		end
	end
end
function modifier_item_butterfly_custom:OnDestroy()
	local hParent = self:GetParent()

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyAgility(-self.bonus_agility)
		end
	end
	
	local butterfly_table = Load(hParent, "butterfly_table") or {}
	for index = #butterfly_table, 1, -1 do
		if butterfly_table[index] == self then
			table.remove(butterfly_table, index)
		end
	end
	Save(hParent, "butterfly_table", butterfly_table)
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_item_butterfly_custom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		-- MODIFIER_EVENT_ON_ATTACK_LANDED,
		
	}
end
function modifier_item_butterfly_custom:GetModifierPreAttack_BonusDamage(params)
	return self.bonus_damage
end
function modifier_item_butterfly_custom:GetModifierBonusStats_Agility(params)
	return self.bonus_agility
end
function modifier_item_butterfly_custom:GetModifierAttackSpeedBonus_Constant(params)
	return self.bonus_attack_speed
end
function modifier_item_butterfly_custom:OnAttackLanded(params)
	if params.target == nil then return end
	if params.target:GetClassname() == "dota_item_drop" then return end

	if params.attacker == self:GetParent() and not params.attacker:HasModifier("modifier_item_butterfly_custom_flutter") and not params.attacker:HasModifier("modifier_item_jasper_daggers_flutter") and self:GetAbility():IsCooldownReady() then
		local jasper_daggers_table = Load(self:GetParent(), "jasper_daggers_table") or {}
		local butterfly_table = Load(self:GetParent(), "butterfly_table") or {}
		local sotm_table = Load(self:GetParent(), "sotm_table") or {}

		if #jasper_daggers_table == 0 and #sotm_table == 0 and butterfly_table[1] == self then
			if PRD(self:GetParent(), self.flutter_chance, "flutter_chance") then
				self:GetAbility():UseResources(true, true, true)
				self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_butterfly_custom_flutter", {duration = self.flutter_duration})
			end
		end
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_butterfly_custom_flutter == nil then
	modifier_item_butterfly_custom_flutter = class({})
end
function modifier_item_butterfly_custom_flutter:IsHidden()
	return false
end
function modifier_item_butterfly_custom_flutter:IsDebuff()
	return false
end
function modifier_item_butterfly_custom_flutter:IsPurgable()
	return false
end
function modifier_item_butterfly_custom_flutter:IsPurgeException()
	return false
end
function modifier_item_butterfly_custom_flutter:IsStunDebuff()
	return false
end
function modifier_item_butterfly_custom_flutter:AllowIllusionDuplicate()
	return false
end
function modifier_item_butterfly_custom_flutter:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_item_butterfly_custom_flutter:OnCreated(params)
	local hParent = self:GetParent()

	self.flutter_base_agility_factor = self:GetAbilitySpecialValueFor("flutter_base_agility_factor")
	self.base_agility = (hParent.GetBaseAgility ~= nil and hParent:GetBaseAgility() or 0)
	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyAgility(self.base_agility * self.flutter_base_agility_factor)
		end
	end
end
function modifier_item_butterfly_custom_flutter:OnRefresh(params)
	local hParent = self:GetParent()

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyAgility(- self.base_agility * self.flutter_base_agility_factor)			
		end
	end

	self.flutter_base_agility_factor = self:GetAbilitySpecialValueFor("flutter_base_agility_factor")
	self.base_agility = (hParent.GetBaseAgility ~= nil and hParent:GetBaseAgility() or 0)

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyAgility(self.base_agility * self.flutter_base_agility_factor)
		end
	end
end
function modifier_item_butterfly_custom_flutter:OnDestroy()
	local hParent = self:GetParent()

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyAgility(- self.base_agility * self.flutter_base_agility_factor)
		end
	end
end
