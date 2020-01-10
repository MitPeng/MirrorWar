LinkLuaModifier("modifier_item_pin_of_the_sea_custom", "abilities/items/item_pin_of_the_sea_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_pin_of_the_sea_custom_cannot_miss", "abilities/items/item_pin_of_the_sea_custom.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_pin_of_the_sea_custom == nil then
	item_pin_of_the_sea_custom = class({})
end
function item_pin_of_the_sea_custom:GetIntrinsicModifierName()
	return "modifier_item_pin_of_the_sea_custom"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_pin_of_the_sea_custom == nil then
	modifier_item_pin_of_the_sea_custom = class({})
end
function modifier_item_pin_of_the_sea_custom:IsHidden()
	return true
end
function modifier_item_pin_of_the_sea_custom:IsDebuff()
	return false
end
function modifier_item_pin_of_the_sea_custom:IsPurgable()
	return false
end
function modifier_item_pin_of_the_sea_custom:IsPurgeException()
	return false
end
function modifier_item_pin_of_the_sea_custom:IsStunDebuff()
	return false
end
function modifier_item_pin_of_the_sea_custom:AllowIllusionDuplicate()
	return false
end
function modifier_item_pin_of_the_sea_custom:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_item_pin_of_the_sea_custom:OnCreated(params)
	self.bonus_intellect = self:GetAbilitySpecialValueFor("bonus_intellect")
	self.bonus_strength = self:GetAbilitySpecialValueFor("bonus_strength")
	self.bonus_agility = self:GetAbilitySpecialValueFor("bonus_agility")
	self.spell_amp = self:GetAbilitySpecialValueFor("spell_amp")
	self.factor = self:GetAbilitySpecialValueFor("factor")
	self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
	self.bonus_attack_speed = self:GetAbilitySpecialValueFor("bonus_attack_speed")
	self.bonus_chance = self:GetAbilitySpecialValueFor("bonus_chance")
	-- self.bonus_chance_damage = self:GetAbilitySpecialValueFor("bonus_chance_damage")
	local hParent = self:GetParent()
	local pin_of_the_sea_table = Load(hParent, "pin_of_the_sea_table") or {}
	table.insert(pin_of_the_sea_table, self)
	Save(hParent, "pin_of_the_sea_table", pin_of_the_sea_table)

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyStrength(self.bonus_strength)
			hParent:ModifyIntellect(self.bonus_intellect)
			hParent:ModifyAgility(self.bonus_agility)
		end
		self.records = {}
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_START, self, self:GetParent())
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_RECORD, self, self:GetParent())
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY, self, self:GetParent())
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_item_pin_of_the_sea_custom:OnRefresh(params)
	local hParent = self:GetParent()

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyStrength(-self.bonus_strength)
			hParent:ModifyIntellect(-self.bonus_intellect)
			hParent:ModifyAgility(-self.bonus_agility)
		end
	end

	self.bonus_intellect = self:GetAbilitySpecialValueFor("bonus_intellect")
	self.bonus_strength = self:GetAbilitySpecialValueFor("bonus_strength")
	self.bonus_agility = self:GetAbilitySpecialValueFor("bonus_agility")
	self.spell_amp = self:GetAbilitySpecialValueFor("spell_amp")
	self.factor = self:GetAbilitySpecialValueFor("factor")
	self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
	self.bonus_attack_speed = self:GetAbilitySpecialValueFor("bonus_attack_speed")
	self.bonus_chance = self:GetAbilitySpecialValueFor("bonus_chance")
	-- self.bonus_chance_damage = self:GetAbilitySpecialValueFor("bonus_chance_damage")

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyStrength(self.bonus_strength)
			hParent:ModifyIntellect(self.bonus_intellect)
			hParent:ModifyAgility(self.bonus_agility)
		end
	end
end
function modifier_item_pin_of_the_sea_custom:OnDestroy()
	local hParent = self:GetParent()

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyStrength(-self.bonus_strength)
			hParent:ModifyIntellect(-self.bonus_intellect)
			hParent:ModifyAgility(-self.bonus_agility)
		end
	end

	local pin_of_the_sea_table = Load(hParent, "pin_of_the_sea_table") or {}
	for index = #pin_of_the_sea_table, 1, -1 do
		if pin_of_the_sea_table[index] == self then
			table.remove(pin_of_the_sea_table, index)
		end
	end

	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_START, self, self:GetParent())
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_RECORD, self, self:GetParent())
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY, self, self:GetParent())
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_item_pin_of_the_sea_custom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE,
		-- MODIFIER_EVENT_ON_ATTACK_START,
		-- MODIFIER_EVENT_ON_ATTACK_RECORD,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		-- MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
		-- MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end
function modifier_item_pin_of_the_sea_custom:GetModifierBonusStats_Intellect(params)
	return self.bonus_intellect
end
function modifier_item_pin_of_the_sea_custom:GetModifierBonusStats_Strength(params)
	return self.bonus_strength
end
function modifier_item_pin_of_the_sea_custom:GetModifierBonusStats_Agility(params)
	return self.bonus_agility
end
function modifier_item_pin_of_the_sea_custom:GetModifierSpellAmplify_PercentageUnique(params)
	return self.spell_amp
end
function modifier_item_pin_of_the_sea_custom:GetModifierPreAttack_BonusDamage(params)
	return self.bonus_damage
end
function modifier_item_pin_of_the_sea_custom:GetModifierAttackSpeedBonus_Constant(params)
	return self.bonus_attack_speed
end
function modifier_item_pin_of_the_sea_custom:OnAttackStart_AttackSystem(params)
	self:OnAttackStart(params)
end
function modifier_item_pin_of_the_sea_custom:OnAttackStart(params)
	if params.target == nil or params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker == self:GetParent() and not params.attacker:IsIllusion() then
		if UnitFilter(params.target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, params.attacker:GetTeamNumber()) == UF_SUCCESS then
			if PRD(self:GetParent(), self.bonus_chance, "item_pin_of_the_sea_custom") then
				params.attacker:AddNewModifier(params.attacker, self:GetAbility(), "modifier_item_pin_of_the_sea_custom_cannot_miss", nil)
			end
		end
	end
end
function modifier_item_pin_of_the_sea_custom:OnAttackRecord(params)
	if params.target == nil or params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker == self:GetParent() and not params.attacker:IsIllusion() then
		if params.attacker:HasModifier("modifier_item_pin_of_the_sea_custom_cannot_miss") then
			table.insert(self.records, params.record)
		end
		params.attacker:RemoveModifierByName("modifier_item_pin_of_the_sea_custom_cannot_miss")
	end
end
function modifier_item_pin_of_the_sea_custom:OnAttackLanded(params)
	if params.target == nil or params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker == self:GetParent() and not params.attacker:IsIllusion() then
		if TableFindKey(self.records, params.record) ~= nil then
			local pin_of_the_sea_table = Load(self:GetParent(), "pin_of_the_sea_table") or {}
			local iParticleID = ParticleManager:CreateParticle("particles/items_fx/yasha_and_kaya_and_sange.vpcf", PATTACH_CUSTOMORIGIN, params.target)
			ParticleManager:SetParticleControlEnt(iParticleID, 0, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(iParticleID)

			local fDamage = (params.attacker:GetStrength()+params.attacker:GetAgility()+params.attacker:GetIntellect())*self.factor
			local tDamageTable = {
				ability = self:GetAbility(),
				victim = params.target,
				attacker = params.attacker,
				damage = fDamage,
				damage_type = DAMAGE_TYPE_PURE,
			}
			ApplyDamage(tDamageTable)

			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, params.target, fDamage, params.attacker:GetPlayerOwner())
			EmitSoundOnLocationWithCaster(params.target:GetAbsOrigin(), "DOTA_Item.MKB.proc", params.attacker)
		end
	end
end
function modifier_item_pin_of_the_sea_custom:OnAttackRecordDestroy(params)
	if params.target == nil or params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker == self:GetParent() and not params.attacker:IsIllusion() then
		ArrayRemove(self.records, params.record)
	end
end
---------------------------------------------------------------------
if modifier_item_pin_of_the_sea_custom_cannot_miss == nil then
	modifier_item_pin_of_the_sea_custom_cannot_miss = class({})
end
function modifier_item_pin_of_the_sea_custom_cannot_miss:IsHidden()
	return true
end
function modifier_item_pin_of_the_sea_custom_cannot_miss:IsDebuff()
	return false
end
function modifier_item_pin_of_the_sea_custom_cannot_miss:IsPurgable()
	return false
end
function modifier_item_pin_of_the_sea_custom_cannot_miss:IsPurgeException()
	return false
end
function modifier_item_pin_of_the_sea_custom_cannot_miss:IsStunDebuff()
	return false
end
function modifier_item_pin_of_the_sea_custom_cannot_miss:AllowIllusionDuplicate()
	return false
end
function modifier_item_pin_of_the_sea_custom_cannot_miss:GetPriority()
	return -1
end
function modifier_item_pin_of_the_sea_custom_cannot_miss:CheckState()
	return {
		[MODIFIER_STATE_CANNOT_MISS] = true,
	}
end
