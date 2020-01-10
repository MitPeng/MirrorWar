LinkLuaModifier("modifier_item_demagicking_maul", "abilities/items/item_demagicking_maul.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_demagicking_maul_attackspeed", "abilities/items/item_demagicking_maul.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_demagicking_maul_debuff", "abilities/items/item_demagicking_maul.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_demagicking_maul_buff", "abilities/items/item_demagicking_maul.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_demagicking_maul_attack_buff", "abilities/items/item_demagicking_maul.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if item_demagicking_maul == nil then
	item_demagicking_maul = class({})
end
function item_demagicking_maul:GetAbilityTextureName()
	local sTextureName = self.BaseClass.GetAbilityTextureName(self)
	local hCaster = self:GetCaster()
	if hCaster then
		local demagicking_maul_table = Load(hCaster, "demagicking_maul_table") or {}
		if self.modifier ~= nil and self.modifier ~= demagicking_maul_table[1] then
			sTextureName = sTextureName.."_disabled" 
		end
	end
	return sTextureName
end
function item_demagicking_maul:GetIntrinsicModifierName()
	return "modifier_item_demagicking_maul"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_demagicking_maul == nil then
	modifier_item_demagicking_maul = class({})
end
function modifier_item_demagicking_maul:IsHidden()
	return true
end
function modifier_item_demagicking_maul:IsDebuff()
	return false
end
function modifier_item_demagicking_maul:IsPurgable()
	return false
end
function modifier_item_demagicking_maul:IsPurgeException()
	return false
end
function modifier_item_demagicking_maul:IsStunDebuff()
	return false
end
function modifier_item_demagicking_maul:AllowIllusionDuplicate()
	return false
end
function modifier_item_demagicking_maul:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_item_demagicking_maul:OnCreated(params)
	local hParent = self:GetParent()

	self.bonus_strength = self:GetAbilitySpecialValueFor("bonus_strength")
	self.bonus_intellect = self:GetAbilitySpecialValueFor("bonus_intellect")
	self.bonus_attack_speed = self:GetAbilitySpecialValueFor("bonus_attack_speed")
	self.bonus_mana_regen = self:GetAbilitySpecialValueFor("bonus_mana_regen")
	self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
	self.bonus_health = self:GetAbilitySpecialValueFor("bonus_health")
	self.kill_bonus_health = self:GetAbilitySpecialValueFor("kill_bonus_health")
	self.slow_duration = self:GetAbilitySpecialValueFor("slow_duration")
	self.proc_damage = self:GetAbilitySpecialValueFor("proc_damage")
	self.steal_duration = self:GetAbilitySpecialValueFor("steal_duration")
	local demagicking_maul_table = Load(hParent, "demagicking_maul_table") or {}
	table.insert(demagicking_maul_table, self)
	Save(hParent, "demagicking_maul_table", demagicking_maul_table)

	self:GetAbility().modifier = self

	if IsServer() then
		if hParent:IsBuilding() and demagicking_maul_table[1] == self then
			hParent:ModifyStrength(self.bonus_strength)
			hParent:ModifyIntellect(self.bonus_intellect)
			hParent:ModifyMaxHealth(self.bonus_health)
		end
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_item_demagicking_maul:OnRefresh(params)
	local hParent = self:GetParent()
	local demagicking_maul_table = Load(hParent, "demagicking_maul_table") or {}

	if IsServer() then
		if hParent:IsBuilding() and demagicking_maul_table[1] == self then
			hParent:ModifyStrength(-self.bonus_strength)
			hParent:ModifyIntellect(-self.bonus_intellect)
			hParent:ModifyMaxHealth(-self.bonus_health)
		end
	end

	self.bonus_strength = self:GetAbilitySpecialValueFor("bonus_strength")
	self.bonus_intellect = self:GetAbilitySpecialValueFor("bonus_intellect")
	self.bonus_attack_speed = self:GetAbilitySpecialValueFor("bonus_attack_speed")
	self.bonus_mana_regen = self:GetAbilitySpecialValueFor("bonus_mana_regen")
	self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
	self.bonus_health = self:GetAbilitySpecialValueFor("bonus_health")
	self.kill_bonus_health = self:GetAbilitySpecialValueFor("kill_bonus_health")
	self.slow_duration = self:GetAbilitySpecialValueFor("slow_duration")
	self.proc_damage = self:GetAbilitySpecialValueFor("proc_damage")
	self.steal_duration = self:GetAbilitySpecialValueFor("steal_duration")

	if IsServer() then
		if hParent:IsBuilding() and demagicking_maul_table[1] == self then
			hParent:ModifyStrength(self.bonus_strength)
			hParent:ModifyIntellect(self.bonus_intellect)
			hParent:ModifyMaxHealth(self.bonus_health)
		end
	end
end
function modifier_item_demagicking_maul:OnDestroy()
	local hParent = self:GetParent()
	local demagicking_maul_table = Load(hParent, "demagicking_maul_table") or {}

	local bEffective = demagicking_maul_table[1] == self

	if IsServer() then
		if hParent:IsBuilding() and bEffective then
			hParent:ModifyStrength(-self.bonus_strength)
			hParent:ModifyIntellect(-self.bonus_intellect)
			hParent:ModifyMaxHealth(-self.bonus_health)
		end
	end

	for index = #demagicking_maul_table, 1, -1 do
		if demagicking_maul_table[index] == self then
			table.remove(demagicking_maul_table, index)
		end
	end
	Save(hParent, "demagicking_maul_table", demagicking_maul_table)

	self:GetAbility().modifier = nil

	if IsServer() and bEffective then
		local modifier = demagicking_maul_table[1]
		if modifier then
			if hParent:IsBuilding() then
				hParent:ModifyStrength(modifier.bonus_strength)
				hParent:ModifyIntellect(modifier.bonus_intellect)
				hParent:ModifyMaxHealth(modifier.bonus_health)
			end
		end
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_item_demagicking_maul:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		-- MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end
function modifier_item_demagicking_maul:GetModifierBonusStats_Strength(params)
	local demagicking_maul_table = Load(self:GetParent(), "demagicking_maul_table") or {}
	if demagicking_maul_table[1] == self then
		return self.bonus_strength
	end
end
function modifier_item_demagicking_maul:GetModifierBonusStats_Intellect(params)
	local demagicking_maul_table = Load(self:GetParent(), "demagicking_maul_table") or {}
	if demagicking_maul_table[1] == self then
		return self.bonus_intellect
	end
end
function modifier_item_demagicking_maul:GetModifierAttackSpeedBonus_Constant(params)
	local demagicking_maul_table = Load(self:GetParent(), "demagicking_maul_table") or {}
	if demagicking_maul_table[1] == self then
		return self.bonus_attack_speed
	end
end
function modifier_item_demagicking_maul:GetModifierPreAttack_BonusDamage(params)
	local demagicking_maul_table = Load(self:GetParent(), "demagicking_maul_table") or {}
	if demagicking_maul_table[1] == self then
		return self.bonus_damage
	end
end
function modifier_item_demagicking_maul:GetModifierMPRegenAmplify_Percentage(params)
	local demagicking_maul_table = Load(self:GetParent(), "demagicking_maul_table") or {}
	if demagicking_maul_table[1] == self then
		return self.bonus_mana_regen
	end
end
function modifier_item_demagicking_maul:GetModifierHealthBonus(params)
	local demagicking_maul_table = Load(self:GetParent(), "demagicking_maul_table") or {}
	if demagicking_maul_table[1] == self then
		return self.bonus_health
	end
end
function modifier_item_demagicking_maul:OnAttackLanded(params)
	local demagicking_maul_table = Load(self:GetParent(), "demagicking_maul_table") or {}
	if params.attacker == self:GetParent() and demagicking_maul_table[1] == self and not params.attacker:IsIllusion() and not params.attacker:AttackFilter(params.record, ATTACK_STATE_NOT_PROCESSPROCS) then
		if self:GetAbility():IsCooldownReady() then
			if params.attacker:GetTeamNumber() ~= params.target:GetTeamNumber() then
				params.target:AddNewModifier(params.attacker, self:GetAbility(), "modifier_item_demagicking_maul_debuff", {duration=self.slow_duration*params.target:GetStatusResistanceFactor()})

				if not params.attacker:AttackFilter(params.record, ATTACK_STATE_SKIPCOUNTING) then
					params.attacker:AddNewModifier(params.attacker, self:GetAbility(), "modifier_item_demagicking_maul_attackspeed", nil)
					if self:GetParent():HasModifier("modifier_item_demagicking_maul_buff") then
						self:GetParent():RemoveModifierByName("modifier_item_demagicking_maul_buff")
					end
					self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_demagicking_maul_buff", {duration = self.steal_duration})			
					self:GetAbility():UseResources(true, true, true)
				end
			end
		end
	end
end
---------------------------------------------------------------------
if modifier_item_demagicking_maul_attackspeed == nil then
	modifier_item_demagicking_maul_attackspeed = class({})
end
function modifier_item_demagicking_maul_attackspeed:IsHidden()
	return true
end
function modifier_item_demagicking_maul_attackspeed:IsDebuff()
	return false
end
function modifier_item_demagicking_maul_attackspeed:IsPurgable()
	return false
end
function modifier_item_demagicking_maul_attackspeed:IsPurgeException()
	return false
end
function modifier_item_demagicking_maul_attackspeed:IsStunDebuff()
	return false
end
function modifier_item_demagicking_maul_attackspeed:AllowIllusionDuplicate()
	return false
end
function modifier_item_demagicking_maul_attackspeed:OnCreated(params)
	self.slow_duration = self:GetAbilitySpecialValueFor("slow_duration")
	self.proc_damage = self:GetAbilitySpecialValueFor("proc_damage")
	self.steal_duration = self:GetAbilitySpecialValueFor("steal_duration")
	if IsServer() then
		self:SetStackCount(1)
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK, self, self:GetParent())
end
function modifier_item_demagicking_maul_attackspeed:OnRefresh(params)
	self.slow_duration = self:GetAbilitySpecialValueFor("slow_duration")
	self.proc_damage = self:GetAbilitySpecialValueFor("proc_damage")
	self.steal_duration = self:GetAbilitySpecialValueFor("steal_duration")
	if IsServer() then
		self:SetStackCount(1)
	end
end
function modifier_item_demagicking_maul_attackspeed:OnDestroy(params)
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK, self, self:GetParent())
end
function modifier_item_demagicking_maul_attackspeed:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		-- MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
	}
end
function modifier_item_demagicking_maul_attackspeed:GetModifierAttackSpeedBonus_Constant(params)
	if IsServer() and self:GetStackCount() == 1 then
		return 9999
	end
end
function modifier_item_demagicking_maul_attackspeed:OnAttack(params)
	if IsServer() then
		if params.attacker == self:GetParent() and not params.attacker:AttackFilter(params.record, ATTACK_STATE_NOT_PROCESSPROCS) then
			if not params.attacker:AttackFilter(params.record, ATTACK_STATE_SKIPCOUNTING) then
				self:SetStackCount(0)
			end
		end
	end
end
function modifier_item_demagicking_maul_attackspeed:GetModifierProcAttack_BonusDamage_Physical(params)
	if not params.attacker:AttackFilter(params.record, ATTACK_STATE_NOT_PROCESSPROCS) then
		params.target:AddNewModifier(params.attacker, self:GetAbility(), "modifier_item_demagicking_maul_debuff", {duration=self.slow_duration*params.target:GetStatusResistanceFactor()})

		if not params.attacker:AttackFilter(params.record, ATTACK_STATE_SKIPCOUNTING) then
			if self:GetStackCount() == 0 then
				self:Destroy()
			end
		end
		return self.proc_damage
	end
end
---------------------------------------------------------------------
if modifier_item_demagicking_maul_debuff == nil then
	modifier_item_demagicking_maul_debuff = class({})
end
function modifier_item_demagicking_maul_debuff:IsHidden()
	return false
end
function modifier_item_demagicking_maul_debuff:IsDebuff()
	return true
end
function modifier_item_demagicking_maul_debuff:IsPurgable()
	return true
end
function modifier_item_demagicking_maul_debuff:IsPurgeException()
	return true
end
function modifier_item_demagicking_maul_debuff:IsStunDebuff()
	return false
end
function modifier_item_demagicking_maul_debuff:AllowIllusionDuplicate()
	return false
end
function modifier_item_demagicking_maul_debuff:OnCreated(params)
	self.movement_slow = self:GetAbilitySpecialValueFor("movement_slow")
end
function modifier_item_demagicking_maul_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end
function modifier_item_demagicking_maul_debuff:GetModifierMoveSpeedBonus_Percentage(params)
	return -self.movement_slow
end
---------------------------------------------------------------------
if modifier_item_demagicking_maul_buff == nil then
	modifier_item_demagicking_maul_buff = class({})
end
function modifier_item_demagicking_maul_buff:IsHidden()
	return false
end
function modifier_item_demagicking_maul_buff:IsDebuff()
	return false
end
function modifier_item_demagicking_maul_buff:IsPurgable()
	return false
end
function modifier_item_demagicking_maul_buff:IsPurgeException()
	return false
end
function modifier_item_demagicking_maul_buff:IsStunDebuff()
	return false
end
function modifier_item_demagicking_maul_buff:AllowIllusionDuplicate()
	return false
end
function modifier_item_demagicking_maul_buff:OnCreated(params)
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
function modifier_item_demagicking_maul_buff:OnDestroy()
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_demagicking_maul_attack_buff", {duration = self.steal_max_duration, steal_health = self.steal_health })
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_item_demagicking_maul_buff:DeclareFunctions()
	return {
		-- MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end
function modifier_item_demagicking_maul_buff:OnAttackLanded(params)
	if params.target == nil then return end 
	if params.target:GetClassname() == "dota_item_drop" then return end
	if IsServer() then
		if params.attacker == self:GetParent() and not params.attacker:IsIllusion() then	
			local bonus_health =  self.str_steal_pct * self:GetParent():GetStrength() * 0.01
			self.steal_health = self.steal_health + bonus_health
			self:SetStackCount(self.steal_health)
			self:GetParent():ModifyMaxHealth(bonus_health)
		end
	end
end
---------------------------------------------------------------------
if modifier_item_demagicking_maul_attack_buff == nil then
	modifier_item_demagicking_maul_attack_buff = class({})
end
function modifier_item_demagicking_maul_attack_buff:IsHidden()
	return false
end
function modifier_item_demagicking_maul_attack_buff:IsDebuff()
	return false
end
function modifier_item_demagicking_maul_attack_buff:IsPurgable()
	return false
end
function modifier_item_demagicking_maul_attack_buff:IsPurgeException()
	return false
end
function modifier_item_demagicking_maul_attack_buff:IsStunDebuff()
	return false
end
function modifier_item_demagicking_maul_attack_buff:AllowIllusionDuplicate()
	return false
end
function modifier_item_demagicking_maul_attack_buff:OnCreated(params)
	self.damage_radius = self:GetAbilitySpecialValueFor("damage_radius")
	self.damage_pct = self:GetAbilitySpecialValueFor("damage_pct")
	if IsServer() then
		self.steal_health = tonumber(params.steal_health)
		self:SetStackCount(math.ceil(self.steal_health))
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_item_demagicking_maul_attack_buff:OnDestroy()
	if IsServer() then
		self.steal_health = self.steal_health or 0
		self:GetParent():ModifyMaxHealth(-self.steal_health)
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_item_demagicking_maul_attack_buff:DeclareFunctions()
	return {
		-- MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end
function modifier_item_demagicking_maul_attack_buff:OnAttackLanded(params)
	if params.target == nil then return end
	if params.target:GetClassname() == "dota_item_drop" then return end
	if IsServer() then 
		if params.attacker == self:GetParent() then
			local particleID = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_timedialate.vpcf", PATTACH_WORLDORIGIN, nil)
			ParticleManager:SetParticleControl(particleID, 0, params.target:GetAbsOrigin())
			ParticleManager:SetParticleControl(particleID, 1, Vector(self.damage_radius, 0, 0))
			ParticleManager:ReleaseParticleIndex(particleID)

			EmitSoundOnLocationWithCaster(params.target:GetAbsOrigin(), "Item.DemagickingMaul.Activate", params.attacker)

			local hCaster = self:GetParent()
			local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), params.target:GetAbsOrigin() , nil, self.damage_radius , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false)
			local fDamage = self:GetStackCount() * self.damage_pct * 0.01 + self:GetParent():GetStrength() * #tTargets
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
