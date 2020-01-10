LinkLuaModifier("modifier_item_jasper_daggers", "abilities/items/item_jasper_daggers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_jasper_daggers_diffusal", "abilities/items/item_jasper_daggers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_jasper_daggers_flutter", "abilities/items/item_jasper_daggers.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if item_jasper_daggers == nil then
	item_jasper_daggers = class({})
end
function item_jasper_daggers:GetAbilityTextureName()
	local sTextureName = self.BaseClass.GetAbilityTextureName(self)
	local hCaster = self:GetCaster()
	if hCaster then
		local jasper_daggers_table = Load(hCaster, "jasper_daggers_table") or {}
		if self.modifier ~= nil and self.modifier ~= jasper_daggers_table[1] then
			sTextureName = sTextureName.."_disabled" 
		end
	end
	return sTextureName
end
function item_jasper_daggers:OnProjectileHit(hTarget, vLocation)
    if hTarget ~= nil then
        local caster = self:GetCaster()
		local factor = self:GetSpecialValueFor("factor")
        local damage = factor/caster:GetSecondsPerAttack()

		local damage_table = 
		{
			ability = self,
			attacker = caster,
			victim = hTarget,
			damage = damage,
			damage_type = DAMAGE_TYPE_PURE
		}
		ApplyDamage(damage_table)
    end
end
function item_jasper_daggers:GetIntrinsicModifierName()
	return "modifier_item_jasper_daggers"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_jasper_daggers == nil then
	modifier_item_jasper_daggers = class({})
end
function modifier_item_jasper_daggers:IsHidden()
	return true
end
function modifier_item_jasper_daggers:IsDebuff()
	return false
end
function modifier_item_jasper_daggers:IsPurgable()
	return false
end
function modifier_item_jasper_daggers:IsPurgeException()
	return false
end
function modifier_item_jasper_daggers:IsStunDebuff()
	return false
end
function modifier_item_jasper_daggers:AllowIllusionDuplicate()
	return false
end
function modifier_item_jasper_daggers:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_item_jasper_daggers:OnCreated(params)
	local hParent = self:GetParent()

	self.bonus_agility = self:GetAbilitySpecialValueFor("bonus_agility")
	self.bonus_intellect = self:GetAbilitySpecialValueFor("bonus_intellect")
	self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
	self.bonus_attack_speed = self:GetAbilitySpecialValueFor("bonus_attack_speed")
	self.feedback_mana_burn = self:GetAbilitySpecialValueFor("feedback_mana_burn")
	self.feedback_mana_burn_illusion_melee = self:GetAbilitySpecialValueFor("feedback_mana_burn_illusion_melee")
	self.feedback_mana_burn_illusion_ranged = self:GetAbilitySpecialValueFor("feedback_mana_burn_illusion_ranged")
	self.damage_per_burn = self:GetAbilitySpecialValueFor("damage_per_burn")
	self.diffusal_duration = self:GetAbilitySpecialValueFor("diffusal_duration")
	self.attack_count = self:GetAbilitySpecialValueFor("attack_count")
	self.speed = self:GetAbilitySpecialValueFor("speed")
	self.range = self:GetAbilitySpecialValueFor("range")
	self.width = self:GetAbilitySpecialValueFor("width")
	self.flutter_chance = self:GetAbilitySpecialValueFor("flutter_chance")
	self.flutter_base_agility_factor = self:GetAbilitySpecialValueFor("flutter_base_agility_factor")
	self.flutter_duration = self:GetAbilitySpecialValueFor("flutter_duration")

	local jasper_daggers_table = Load(hParent, "jasper_daggers_table") or {}
	table.insert(jasper_daggers_table, self)
	Save(hParent, "jasper_daggers_table", jasper_daggers_table)

	self:GetAbility().modifier = self

	if IsServer() then
		if hParent:IsBuilding() and jasper_daggers_table[1] == self then
			hParent:ModifyAgility(self.bonus_agility)
			hParent:ModifyIntellect(self.bonus_intellect)
		end
	end

	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK, self, self:GetParent())
end
function modifier_item_jasper_daggers:OnRefresh(params)
	local hParent = self:GetParent()
	local jasper_daggers_table = Load(hParent, "jasper_daggers_table") or {}

	if IsServer() then
		if hParent:IsBuilding() and jasper_daggers_table[1] == self then
			hParent:ModifyAgility(-self.bonus_agility)
			hParent:ModifyIntellect(-self.bonus_intellect)
		end
	end

	self.bonus_agility = self:GetAbilitySpecialValueFor("bonus_agility")
	self.bonus_intellect = self:GetAbilitySpecialValueFor("bonus_intellect")
	self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
	self.bonus_attack_speed = self:GetAbilitySpecialValueFor("bonus_attack_speed")
	self.feedback_mana_burn = self:GetAbilitySpecialValueFor("feedback_mana_burn")
	self.feedback_mana_burn_illusion_melee = self:GetAbilitySpecialValueFor("feedback_mana_burn_illusion_melee")
	self.feedback_mana_burn_illusion_ranged = self:GetAbilitySpecialValueFor("feedback_mana_burn_illusion_ranged")
	self.damage_per_burn = self:GetAbilitySpecialValueFor("damage_per_burn")
	self.diffusal_duration = self:GetAbilitySpecialValueFor("diffusal_duration")
	self.attack_count = self:GetAbilitySpecialValueFor("attack_count")
	self.speed = self:GetAbilitySpecialValueFor("speed")
	self.range = self:GetAbilitySpecialValueFor("range")
	self.width = self:GetAbilitySpecialValueFor("width")
	self.flutter_chance = self:GetAbilitySpecialValueFor("flutter_chance")
	self.flutter_base_agility_factor = self:GetAbilitySpecialValueFor("flutter_base_agility_factor")
	self.flutter_duration = self:GetAbilitySpecialValueFor("flutter_duration")

	if IsServer() then
		if hParent:IsBuilding() and jasper_daggers_table[1] == self then
			hParent:ModifyAgility(self.bonus_agility)
			hParent:ModifyIntellect(self.bonus_intellect)
		end
	end
end
function modifier_item_jasper_daggers:OnDestroy()
	local hParent = self:GetParent()
	local jasper_daggers_table = Load(hParent, "jasper_daggers_table") or {}

	local bEffective = jasper_daggers_table[1] == self

	if IsServer() then
		if hParent:IsBuilding() and bEffective then
			hParent:ModifyAgility(-self.bonus_agility)
			hParent:ModifyIntellect(-self.bonus_intellect)
		end
	end

	for index = #jasper_daggers_table, 1, -1 do
		if jasper_daggers_table[index] == self then
			table.remove(jasper_daggers_table, index)
		end
	end
	Save(hParent, "jasper_daggers_table", jasper_daggers_table)

	self:GetAbility().modifier = nil

	if IsServer() and bEffective then
		local modifier = jasper_daggers_table[1]
		if modifier then
			if hParent:IsBuilding() then
				hParent:ModifyAgility(modifier.bonus_agility)
				hParent:ModifyIntellect(modifier.bonus_intellect)
			end
		end
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK, self, self:GetParent())
end
function modifier_item_jasper_daggers:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		-- MODIFIER_EVENT_ON_ATTACK,
		-- MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
end
function modifier_item_jasper_daggers:GetModifierBonusStats_Agility(params)
	local jasper_daggers_table = Load(self:GetParent(), "jasper_daggers_table") or {}
	if jasper_daggers_table[1] == self then
		return self.bonus_agility
	end
end
function modifier_item_jasper_daggers:GetModifierBonusStats_Intellect(params)
	local jasper_daggers_table = Load(self:GetParent(), "jasper_daggers_table") or {}
	if jasper_daggers_table[1] == self then
		return self.bonus_intellect
	end
end
function modifier_item_jasper_daggers:GetModifierPreAttack_BonusDamage(params)
	local jasper_daggers_table = Load(self:GetParent(), "jasper_daggers_table") or {}
	if jasper_daggers_table[1] == self then
		return self.bonus_damage
	end
end
function modifier_item_jasper_daggers:GetModifierAttackSpeedBonus_Constant(params)
	local jasper_daggers_table = Load(self:GetParent(), "jasper_daggers_table") or {}
	if jasper_daggers_table[1] == self then
		return self.bonus_attack_speed
	end
end
function modifier_item_jasper_daggers:OnAttack(params)
	if params.target == nil then return end
	if params.target:GetClassname() == "dota_item_drop" then return end

    local jasper_daggers_table = Load(self:GetParent(), "jasper_daggers_table") or {}
    if params.attacker == self:GetParent() and not params.attacker:IsIllusion() and jasper_daggers_table[1] == self and not params.attacker:AttackFilter(params.record, ATTACK_STATE_NOT_PROCESSPROCS, ATTACK_STATE_SKIPCOUNTING) then
        if params.attacker:IsRangedAttacker() then return end

        if not params.attacker.GetAgility == nil then return end

        local item = self:GetAbility()
        if item then
            local charges = item:GetCurrentCharges()
            charges = charges + 1

            if charges >= self.attack_count then
                charges = 0

                local vDirection = params.target:GetAbsOrigin() - params.attacker:GetAbsOrigin()
                vDirection.z = 0

                local info = {
                    Ability = item,
                    Source = params.attacker,
                    EffectName = "particles/items_fx/jasper_daggers.vpcf",
                    vSpawnOrigin = params.attacker:GetAbsOrigin(),
                    vVelocity = vDirection:Normalized() * self.speed,
                    fDistance = self.range,
                    fStartRadius = self.width,
                    fEndRadius = self.width,
                    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
                    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                }
                ProjectileManager:CreateLinearProjectile(info)

                params.attacker:EmitSound("Item.JasperDaggers.Passive")
            end

            item:SetCurrentCharges(charges)
        end
    end
end
function modifier_item_jasper_daggers:GetModifierProcAttack_Feedback(params)
	local hCaster = params.attacker
	local hTarget = params.target
	local jasper_daggers_table = Load(self:GetParent(), "jasper_daggers_table") or {}
	if jasper_daggers_table[1] == self and not hCaster:AttackFilter(params.record, ATTACK_STATE_NOT_PROCESSPROCS) and UnitFilter(hTarget, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_MANA_ONLY, hCaster:GetTeamNumber()) == UF_SUCCESS then
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
			hTarget:AddNewModifier(hCaster, self:GetAbility(), "modifier_item_jasper_daggers_diffusal", {duration = self.diffusal_duration * hTarget:GetStatusResistanceFactor()})
		end

		return fDamage
	end
	return 0
end
function modifier_item_jasper_daggers:OnAttackLanded(params)
	if params.target == nil then return end
	if params.target:GetClassname() == "dota_item_drop" then return end

	if params.attacker == self:GetParent() and not params.attacker:HasModifier("modifier_item_butterfly_custom_flutter") and not params.attacker:HasModifier("modifier_item_jasper_daggers_flutter") and self:GetAbility():IsCooldownReady() then
		local jasper_daggers_table = Load(self:GetParent(), "jasper_daggers_table") or {}
		if jasper_daggers_table[1] == self then
			if PRD(self:GetParent(), self.flutter_chance, "flutter_chance") then
				self:GetAbility():UseResources(true, true, true)
				self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_jasper_daggers_flutter", {duration = self.flutter_duration})
			end
		end
	end
end
---------------------------------------------------------------------
if modifier_item_jasper_daggers_diffusal == nil then
	modifier_item_jasper_daggers_diffusal = class({})
end
function modifier_item_jasper_daggers_diffusal:IsHidden()
	return false
end
function modifier_item_jasper_daggers_diffusal:IsDebuff()
	return true
end
function modifier_item_jasper_daggers_diffusal:IsPurgable()
	return true
end
function modifier_item_jasper_daggers_diffusal:IsPurgeException()
	return true
end
function modifier_item_jasper_daggers_diffusal:IsStunDebuff()
	return false
end
function modifier_item_jasper_daggers_diffusal:AllowIllusionDuplicate()
	return false
end
function modifier_item_jasper_daggers_diffusal:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_item_jasper_daggers_diffusal:OnCreated(params)
	local hParent = self:GetParent()
	self.diffusal_movespeed_bonus = self:GetAbilitySpecialValueFor("diffusal_movespeed_bonus")
	self.total_duraiton = self:GetDuration()
	local nIndexFX = ParticleManager:CreateParticle("particles/items_fx/diffusal_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	self:AddParticle(nIndexFX, false, false, -1, false, false)
end
function modifier_item_jasper_daggers_diffusal:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end
function modifier_item_jasper_daggers_diffusal:GetModifierMoveSpeedBonus_Percentage()
	return self.diffusal_movespeed_bonus * (self:GetRemainingTime() / self.total_duraiton)
end
---------------------------------------------------------------------
if modifier_item_jasper_daggers_flutter == nil then
	modifier_item_jasper_daggers_flutter = class({})
end
function modifier_item_jasper_daggers_flutter:IsHidden()
	return false
end
function modifier_item_jasper_daggers_flutter:IsDebuff()
	return false
end
function modifier_item_jasper_daggers_flutter:IsPurgable()
	return false
end
function modifier_item_jasper_daggers_flutter:IsPurgeException()
	return false
end
function modifier_item_jasper_daggers_flutter:IsStunDebuff()
	return false
end
function modifier_item_jasper_daggers_flutter:AllowIllusionDuplicate()
	return false
end
function modifier_item_jasper_daggers_flutter:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_item_jasper_daggers_flutter:OnCreated(params)
	local hParent = self:GetParent()

	self.flutter_base_agility_factor = self:GetAbilitySpecialValueFor("flutter_base_agility_factor")
	self.base_agility = (hParent.GetBaseAgility ~= nil and hParent:GetBaseAgility() or 0)
	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyAgility(self.base_agility * self.flutter_base_agility_factor)
		end
	end
end
function modifier_item_jasper_daggers_flutter:OnRefresh(params)
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
function modifier_item_jasper_daggers_flutter:OnDestroy()
	local hParent = self:GetParent()

	if IsServer() then
		if hParent:IsBuilding() then
			hParent:ModifyAgility(- self.base_agility * self.flutter_base_agility_factor)
		end
	end
end
