LinkLuaModifier("modifier_item_rod_of_atos_custom", "abilities/items/item_rod_of_atos_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_rod_of_atos_custom_thinker", "abilities/items/item_rod_of_atos_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_rod_of_atos_custom_effect", "abilities/items/item_rod_of_atos_custom.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_rod_of_atos_custom == nil then
	item_rod_of_atos_custom = class({})
end
function item_rod_of_atos_custom:GetIntrinsicModifierName()
	return "modifier_item_rod_of_atos_custom"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_rod_of_atos_custom == nil then
	modifier_item_rod_of_atos_custom = class({})
end
function modifier_item_rod_of_atos_custom:IsHidden()
	return true
end
function modifier_item_rod_of_atos_custom:IsDebuff()
	return false
end
function modifier_item_rod_of_atos_custom:IsPurgable()
	return false
end
function modifier_item_rod_of_atos_custom:IsPurgeException()
	return false
end
function modifier_item_rod_of_atos_custom:IsStunDebuff()
	return false
end
function modifier_item_rod_of_atos_custom:AllowIllusionDuplicate()
	return false
end
function modifier_item_rod_of_atos_custom:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_item_rod_of_atos_custom:OnCreated(params)
	local hParent = self:GetParent()

	self.bonus_intellect = self:GetAbilitySpecialValueFor("bonus_intellect")
	self.bonus_strength = self:GetAbilitySpecialValueFor("bonus_strength")
	self.bonus_agility = self:GetAbilitySpecialValueFor("bonus_agility")
	self.flower_duration = self:GetAbilitySpecialValueFor("flower_duration")
	self.flower_delay = self:GetAbilitySpecialValueFor("flower_delay")

	local rod_of_atos_table = Load(hParent, "rod_of_atos_table") or {}
	table.insert(rod_of_atos_table, self)
	Save(hParent, "rod_of_atos_table", rod_of_atos_table)

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyStrength(self.bonus_strength)
			hParent:ModifyAgility(self.bonus_agility)
			hParent:ModifyIntellect(self.bonus_intellect)
		end
	end
	AddModifierEvents(MODIFIER_EVENT_ON_DEATH, self)
end
function modifier_item_rod_of_atos_custom:OnRefresh(params)
	local hParent = self:GetParent()
	local rod_of_atos_table = Load(hParent, "rod_of_atos_table") or {}

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyStrength(-self.bonus_strength)
			hParent:ModifyAgility(-self.bonus_agility)
			hParent:ModifyIntellect(-self.bonus_intellect)
		end
	end

	self.bonus_intellect = self:GetAbilitySpecialValueFor("bonus_intellect")
	self.bonus_strength = self:GetAbilitySpecialValueFor("bonus_strength")
	self.bonus_agility = self:GetAbilitySpecialValueFor("bonus_agility")
	self.flower_duration = self:GetAbilitySpecialValueFor("flower_duration")
	self.flower_delay = self:GetAbilitySpecialValueFor("flower_delay")

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyStrength(self.bonus_strength)
			hParent:ModifyAgility(self.bonus_agility)
			hParent:ModifyIntellect(self.bonus_intellect)
		end
	end
end
function modifier_item_rod_of_atos_custom:OnDestroy()
	local hParent = self:GetParent()
	local rod_of_atos_table = Load(hParent, "rod_of_atos_table") or {}

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyStrength(-self.bonus_strength)
			hParent:ModifyAgility(-self.bonus_agility)
			hParent:ModifyIntellect(-self.bonus_intellect)
		end
	end

	for index = #rod_of_atos_table, 1, -1 do
		if rod_of_atos_table[index] == self then
			table.remove(rod_of_atos_table, index)
		end
	end
	Save(hParent, "rod_of_atos_table", rod_of_atos_table)

	RemoveModifierEvents(MODIFIER_EVENT_ON_DEATH, self)
end
function modifier_item_rod_of_atos_custom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		-- MODIFIER_EVENT_ON_DEATH,
	}
end
function modifier_item_rod_of_atos_custom:GetModifierBonusStats_Strength(params)
	return self.bonus_strength
end
function modifier_item_rod_of_atos_custom:GetModifierBonusStats_Agility(params)
	return self.bonus_agility
end
function modifier_item_rod_of_atos_custom:GetModifierBonusStats_Intellect(params)
	return self.bonus_intellect
end
function modifier_item_rod_of_atos_custom:OnDeath(params)
	local hAttacker = params.attacker
	local hAttackerAbility = params.inflictor
	if not IsValid(hAttacker) then return end
	if not IsValid(hAttackerAbility) then return end
	if hAttacker:GetTeamNumber() == params.unit:GetTeamNumber() then return end
	if hAttacker ~= nil and hAttacker:GetUnitLabel() ~= "builder" then
		if hAttacker:IsSummoned() or hAttacker:IsIllusion() then
			hAttacker = IsValid(hAttacker:GetSummoner()) and hAttacker:GetSummoner() or hAttacker
		end
		if hAttacker == self:GetParent() and not hAttacker:IsIllusion() and hAttackerAbility:GetCaster() == hAttacker then
			local rod_of_atos_table = Load(self:GetParent(), "rod_of_atos_table") or {}
			local vPosition = params.unit:GetAbsOrigin()
			local hCaster = hAttacker
			if rod_of_atos_table[1] == self and self:GetAbility():IsCooldownReady() then
				self:GetAbility():UseResources(true, true, true)
				CreateModifierThinker(hCaster, self:GetAbility(), "modifier_item_rod_of_atos_custom_thinker", {duration=self.flower_duration}, vPosition, hCaster:GetTeamNumber(), false)
			end
		end
	end
end
---------------------------------------------------------------------
if modifier_item_rod_of_atos_custom_thinker == nil then
	modifier_item_rod_of_atos_custom_thinker = class({})
end
function modifier_item_rod_of_atos_custom_thinker:IsHidden()
	return false
end
function modifier_item_rod_of_atos_custom_thinker:IsDebuff()
	return false
end
function modifier_item_rod_of_atos_custom_thinker:IsPurgable()
	return false
end
function modifier_item_rod_of_atos_custom_thinker:IsPurgeException()
	return false
end
function modifier_item_rod_of_atos_custom_thinker:IsStunDebuff()
	return false
end
function modifier_item_rod_of_atos_custom_thinker:AllowIllusionDuplicate()
	return false
end
function modifier_item_rod_of_atos_custom_thinker:OnCreated(params)
	self.flower_delay = self:GetAbilitySpecialValueFor("flower_delay")
	self.flower_radius = self:GetAbilitySpecialValueFor("flower_radius")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_willow/dark_willow_bramble_wraith.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, GetGroundPosition(self:GetParent():GetAbsOrigin(), nil))
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.flower_radius, self.flower_radius, self.flower_radius))
		self:AddParticle(iParticleID, true, false, -1, false, false)

		self:StartIntervalThink(self.flower_delay)
	end
end
function modifier_item_rod_of_atos_custom_thinker:OnRefresh(params)
	self.flower_delay = self:GetAbilitySpecialValueFor("flower_delay")
	self.flower_radius = self:GetAbilitySpecialValueFor("flower_radius")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
	end
end
function modifier_item_rod_of_atos_custom_thinker:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveSelf()
	end
end
function modifier_item_rod_of_atos_custom_thinker:OnIntervalThink()
	if IsServer() then
		local hCaster = self:GetCaster()
		local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.flower_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false)
		local hTarget = tTargets[1]
		if hTarget ~= nil then
			hTarget:AddNewModifier(hCaster, self:GetAbility(), "modifier_item_rod_of_atos_custom_effect", {duration=self.duration*hTarget:GetStatusResistanceFactor()})
			self:StartIntervalThink(-1)
			self:Destroy()
		else
			self:StartIntervalThink(0)
		end
	end
end
function modifier_item_rod_of_atos_custom_thinker:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}
end
---------------------------------------------------------------------
if modifier_item_rod_of_atos_custom_effect == nil then
	modifier_item_rod_of_atos_custom_effect = class({})
end
function modifier_item_rod_of_atos_custom_effect:IsHidden()
	return false
end
function modifier_item_rod_of_atos_custom_effect:IsDebuff()
	return true
end
function modifier_item_rod_of_atos_custom_effect:IsPurgable()
	return false
end
function modifier_item_rod_of_atos_custom_effect:IsPurgeException()
	return false
end
function modifier_item_rod_of_atos_custom_effect:IsStunDebuff()
	return false
end
function modifier_item_rod_of_atos_custom_effect:AllowIllusionDuplicate()
	return false
end
function modifier_item_rod_of_atos_custom_effect:GetEffectName()
	return "particles/units/heroes/hero_dark_willow/dark_willow_bramble.vpcf"
end
function modifier_item_rod_of_atos_custom_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_item_rod_of_atos_custom_effect:OnCreated(params)
	self.magic_resistance_bonus = self:GetAbilitySpecialValueFor("magic_resistance_bonus")
	if IsServer() then
		self:GetCaster():EmitSound("Hero_DarkWillow.Bramble.Target")
	end
end
function modifier_item_rod_of_atos_custom_effect:OnRefresh(params)
	self.magic_resistance_bonus = self:GetAbilitySpecialValueFor("magic_resistance_bonus")
end
function modifier_item_rod_of_atos_custom_effect:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
	}
end
function modifier_item_rod_of_atos_custom_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end
function modifier_item_rod_of_atos_custom_effect:GetModifierMagicalResistanceBonus(params)
	return self.magic_resistance_bonus
end