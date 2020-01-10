LinkLuaModifier("modifier_item_satanic_custom", "abilities/items/item_satanic_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_satanic_custom_buff", "abilities/items/item_satanic_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_satanic_custom_attack_buff", "abilities/items/item_satanic_custom.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if item_satanic_custom == nil then
	item_satanic_custom = class({})
end
function item_satanic_custom:GetAbilityTextureName()
	local sTextureName = self.BaseClass.GetAbilityTextureName(self)
	-- local hCaster = self:GetCaster()
	-- if hCaster then
	-- 	local satanic_table = Load(hCaster, "satanic_table") or {}
	-- 	if self.modifier ~= nil and self.modifier ~= satanic_table[1] then
	-- 		sTextureName = sTextureName.."_disabled" 
	-- 	end
	-- end
	return sTextureName
end
function item_satanic_custom:GetIntrinsicModifierName()
	return "modifier_item_satanic_custom"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_satanic_custom == nil then
	modifier_item_satanic_custom = class({})
end
function modifier_item_satanic_custom:IsHidden()
	return true
end
function modifier_item_satanic_custom:IsDebuff()
	return false
end
function modifier_item_satanic_custom:IsPurgable()
	return false
end
function modifier_item_satanic_custom:IsPurgeException()
	return false
end
function modifier_item_satanic_custom:IsStunDebuff()
	return false
end
function modifier_item_satanic_custom:AllowIllusionDuplicate()
	return false
end
function modifier_item_satanic_custom:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_item_satanic_custom:OnCreated(params)
	local hParent = self:GetParent()

	self.bonus_strength = self:GetAbilitySpecialValueFor("bonus_strength")
	self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
	self.str_steal_pct = self:GetAbilitySpecialValueFor("str_steal_pct")
	self.steal_duration = self:GetAbilitySpecialValueFor("steal_duration")
	local satanic_table = Load(hParent, "satanic_table") or {}
	table.insert(satanic_table, self)
	Save(hParent, "satanic_table", satanic_table)

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyStrength(self.bonus_strength)
		end
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_START, self, self:GetParent())
end
function modifier_item_satanic_custom:OnRefresh(params)
	local hParent = self:GetParent()
	local satanic_table = Load(hParent, "satanic_table") or {}

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyStrength(-self.bonus_strength)
		end
	end

	self.bonus_strength = self:GetAbilitySpecialValueFor("bonus_strength")
	self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
	self.str_steal_pct = self:GetAbilitySpecialValueFor("str_steal_pct")
	self.steal_duration = self:GetAbilitySpecialValueFor("steal_duration")

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyStrength(self.bonus_strength)
		end
	end
end
function modifier_item_satanic_custom:OnDestroy()
	local hParent = self:GetParent()
	local satanic_table = Load(hParent, "satanic_table") or {}

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyStrength(-self.bonus_strength)
		end
	end

	for index = #satanic_table, 1, -1 do
		if satanic_table[index] == self then
			table.remove(satanic_table, index)
		end
	end
	Save(hParent, "satanic_table", satanic_table)

	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_START, self, self:GetParent())
end
function modifier_item_satanic_custom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		-- MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
	}
end
function modifier_item_satanic_custom:GetModifierBonusStats_Strength(params)
	return self.bonus_strength
end
function modifier_item_satanic_custom:GetModifierPreAttack_BonusDamage(params)
	return self.bonus_damage
end
function modifier_item_satanic_custom:OnAttackStart_AttackSystem(params)
	self:OnAttackStart(params)
end
function modifier_item_satanic_custom:OnAttackStart(params)
	if params.target == nil then return end
	if params.target:GetClassname() == "dota_item_drop" then return end

	local satanic_table = Load(self:GetParent(), "satanic_table") or {}
	local demagicking_maul_table = Load(self:GetParent(), "demagicking_maul_table") or {}
	if params.attacker == self:GetParent() and #demagicking_maul_table == 0 and satanic_table[1] == self and self:GetAbility():IsCooldownReady() and not params.attacker:HasModifier("modifier_item_satanic_custom_buff") and not params.attacker:HasModifier("modifier_item_satanic_custom_attack_buff") and satanic_table[1] == self and not params.attacker:IsIllusion() and not params.attacker:AttackFilter(params.record, ATTACK_STATE_NOT_PROCESSPROCS) and UnitFilter(params.target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, params.attacker:GetTeamNumber()) == UF_SUCCESS then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_satanic_custom_buff", {duration = self.steal_duration})
		self:GetAbility():UseResources(true, true, true)
	end
end

---------------------------------------------------------------------
if modifier_item_satanic_custom_buff == nil then
	modifier_item_satanic_custom_buff = class({})
end
function modifier_item_satanic_custom_buff:IsHidden()
	return false
end
function modifier_item_satanic_custom_buff:IsDebuff()
	return false
end
function modifier_item_satanic_custom_buff:IsPurgable()
	return false
end
function modifier_item_satanic_custom_buff:IsPurgeException()
	return false
end
function modifier_item_satanic_custom_buff:IsStunDebuff()
	return false
end
function modifier_item_satanic_custom_buff:AllowIllusionDuplicate()
	return false
end
function modifier_item_satanic_custom_buff:OnCreated(params)
	self.str_steal_pct = self:GetAbilitySpecialValueFor("str_steal_pct")
	self.steal_max_duration = self:GetAbilitySpecialValueFor("steal_max_duration")
	self.steal_health = 0
	if IsServer() then
		local EffectName = "particles/items2_fx/satanic_buff.vpcf"
		local nIndexFX = ParticleManager:CreateParticle(EffectName, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		-- ParticleManager:ReleaseParticleIndex(nIndexFX)
		self:AddParticle(nIndexFX, false, false, -1, false, false)
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_item_satanic_custom_buff:OnDestroy()
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_satanic_custom_attack_buff", {duration = self.steal_max_duration, steal_health = self.steal_health })
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_item_satanic_custom_buff:DeclareFunctions()
	return {
		-- MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end
function modifier_item_satanic_custom_buff:OnAttackLanded(params)
	if params.target == nil then return end 
	if params.target:GetClassname() == "dota_item_drop" then return end
	if IsServer() then
		if params.attacker == self:GetParent() and not params.attacker:IsIllusion() then	
			local bonus_health =  math.ceil(self.str_steal_pct * self:GetParent():GetStrength() * 0.01)
			self.steal_health = self.steal_health + bonus_health
			self:SetStackCount(self.steal_health)
			self:GetParent():ModifyMaxHealth(bonus_health)
		end
	end
end
---------------------------------------------------------------------
if modifier_item_satanic_custom_attack_buff == nil then
	modifier_item_satanic_custom_attack_buff = class({})
end
function modifier_item_satanic_custom_attack_buff:IsHidden()
	return false
end
function modifier_item_satanic_custom_attack_buff:IsDebuff()
	return false
end
function modifier_item_satanic_custom_attack_buff:IsPurgable()
	return false
end
function modifier_item_satanic_custom_attack_buff:IsPurgeException()
	return false
end
function modifier_item_satanic_custom_attack_buff:IsStunDebuff()
	return false
end
function modifier_item_satanic_custom_attack_buff:AllowIllusionDuplicate()
	return false
end
function modifier_item_satanic_custom_attack_buff:OnCreated(params)
	self.damage_radius = self:GetAbilitySpecialValueFor("damage_radius")
	self.damage_pct = self:GetAbilitySpecialValueFor("damage_pct")
	if IsServer() then
		self.steal_health = tonumber(params.steal_health)
		self:SetStackCount(math.ceil(self.steal_health))
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_item_satanic_custom_attack_buff:OnDestroy()
	if IsServer() then
		self.steal_health = self.steal_health or 0
		self:GetParent():ModifyMaxHealth(-self.steal_health)
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_item_satanic_custom_attack_buff:DeclareFunctions()
	return {
		-- MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end
function modifier_item_satanic_custom_attack_buff:OnAttackLanded(params)
	if params.target == nil then return end
	if params.target:GetClassname() == "dota_item_drop" then return end
	if IsServer() then 
		if params.attacker == self:GetParent() then
			local hCaster = self:GetParent()
			local fDamage = self:GetStackCount() * self.damage_pct * 0.01
			local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), params.target:GetAbsOrigin() , nil, self.damage_radius , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false)
			for _, hTarget in pairs(tTargets) do
				local tDamageTable = {
					victim = hTarget,
					attacker = hCaster,
					damage =  fDamage,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					ability = self:GetAbility(),
				}
				ApplyDamage(tDamageTable)
			end
			self:Destroy()
		end
	end
end
