LinkLuaModifier("modifier_item_sealed_holy_cape", "abilities/items/item_sealed_holy_cape.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_sealed_holy_cape == nil then
	item_sealed_holy_cape = class({})
end
function item_sealed_holy_cape:GetIntrinsicModifierName()
	return "modifier_item_sealed_holy_cape"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_sealed_holy_cape == nil then
	modifier_item_sealed_holy_cape = class({})
end
function modifier_item_sealed_holy_cape:IsHidden()
	return true
end
function modifier_item_sealed_holy_cape:IsDebuff()
	return false
end
function modifier_item_sealed_holy_cape:IsPurgable()
	return false
end
function modifier_item_sealed_holy_cape:IsPurgeException()
	return false
end
function modifier_item_sealed_holy_cape:IsStunDebuff()
	return false
end
function modifier_item_sealed_holy_cape:AllowIllusionDuplicate()
	return false
end
function modifier_item_sealed_holy_cape:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_item_sealed_holy_cape:OnCreated(params)
	self.kills_stats = self:GetAbilitySpecialValueFor("kills_stats")
	self.bonus_pure_damage = self:GetAbilitySpecialValueFor("bonus_pure_damage")
	self.max_kills = self:GetAbilitySpecialValueFor("max_kills")
	local sealed_holy_cape = Load(self:GetParent(), "sealed_holy_cape") or {}
	table.insert(sealed_holy_cape, self)
	Save(self:GetParent(), "sealed_holy_cape", sealed_holy_cape)

	local sealed_table = Load(self:GetParent(), "sealed_table") or {}
	table.insert(sealed_table, self)
	Save(self:GetParent(), "sealed_table", sealed_table)

	if IsServer() then
		self:UpdatePureDamagePercent()
	end

	AddModifierEvents(MODIFIER_EVENT_ON_DEATH, self)
end
function modifier_item_sealed_holy_cape:OnRefresh(params)
	self.kills_stats = self:GetAbilitySpecialValueFor("kills_stats")
	self.bonus_pure_damage = self:GetAbilitySpecialValueFor("bonus_pure_damage")
	self.max_kills = self:GetAbilitySpecialValueFor("max_kills")

	if IsServer() then
		self:UpdatePureDamagePercent()
	end
end
function modifier_item_sealed_holy_cape:OnDestroy()
	local sealed_holy_cape = Load(self:GetParent(), "sealed_holy_cape") or {}
	for index = #sealed_holy_cape, 1, -1 do
		if sealed_holy_cape[index] == self then
			table.remove(sealed_holy_cape, index)
		end
	end
	Save(self:GetParent(), "sealed_holy_cape", sealed_holy_cape)

	if IsServer() then
		if self.key then
			SetOutgoingDamagePercent(self:GetParent(), DAMAGE_TYPE_PURE, nil, self.key)
			if sealed_holy_cape[1] ~= nil then
				sealed_holy_cape[1]:UpdatePureDamagePercent()
			end
		end
	end

	local sealed_table = Load(self:GetParent(), "sealed_table") or {}
	for index = #sealed_table, 1, -1 do
		if sealed_table[index] == self then
			table.remove(sealed_table, index)
		end
	end
	Save(self:GetParent(), "sealed_table", sealed_table)

	RemoveModifierEvents(MODIFIER_EVENT_ON_DEATH, self)
end
function modifier_item_sealed_holy_cape:UpdatePureDamagePercent()
	if IsServer() then
		local modifier = self
		local max = modifier:GetAbility() and modifier:GetAbility():GetCurrentCharges() or 0

		local sealed_holy_cape = Load(self:GetParent(), "sealed_holy_cape") or {}
		for k, v in pairs(sealed_holy_cape) do
			local value = v:GetAbility() and v:GetAbility():GetCurrentCharges() or 0
			if value > max then
				modifier = v
				max = value
			else
				if v.key then
					SetOutgoingDamagePercent(v:GetParent(), DAMAGE_TYPE_PURE, nil, v.key)
				end
			end
		end
		local percent = math.floor(max/modifier.kills_stats) * modifier.bonus_pure_damage
		if modifier.key == nil then
			modifier.key = SetOutgoingDamagePercent(modifier:GetParent(), DAMAGE_TYPE_PURE, percent)
		else
			SetOutgoingDamagePercent(modifier:GetParent(), DAMAGE_TYPE_PURE, percent, modifier.key)
		end
	end
end
function modifier_item_sealed_holy_cape:DeclareFunctions()
	return {
		-- MODIFIER_EVENT_ON_DEATH,
	}
end
function modifier_item_sealed_holy_cape:OnDeath(params)
	local hAttacker = params.attacker
	if not IsValid(hAttacker) then return end
	if hAttacker:GetTeamNumber() == params.unit:GetTeamNumber() then return end
	if hAttacker ~= nil and hAttacker:GetUnitLabel() ~= "builder" then
		if hAttacker:IsSummoned() or hAttacker:IsIllusion() then
			hAttacker = IsValid(hAttacker:GetSummoner()) and hAttacker:GetSummoner() or hAttacker
		end
		if hAttacker == self:GetParent() and not hAttacker:IsIllusion() then
			local sealed_table = Load(self:GetParent(), "sealed_table") or {}
			if sealed_table[1] == self then
				local item = self:GetAbility()
				if item ~= nil then
					local factor = params.unit:IsConsideredHero() and 5 or 1
					item:SetCurrentCharges(item:GetCurrentCharges()+factor)
					self:UpdatePureDamagePercent()

					if item:GetCurrentCharges() >= self.max_kills then
						item:SetCurrentCharges(0)
						hAttacker:ReplaceItem(item, "item_holy_cape")
					end
				end
			end
		end
	end
end