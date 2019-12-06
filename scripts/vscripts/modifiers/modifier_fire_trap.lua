if modifier_fire_trap == nil then modifier_fire_trap = class({}) end

function modifier_fire_trap:IsHidden() return true end
function modifier_fire_trap:IsDebuff() return false end
function modifier_fire_trap:IsPurgable() return false end
function modifier_fire_trap:IsPurgeException() return false end
function modifier_fire_trap:DestroyOnExpire() return false end
function modifier_fire_trap:RemoveOnDeath() return true end

function modifier_fire_trap:OnCreated(params)
    local hero = self:GetParent()
    local attacker
    if hero.get_attacker then
        attacker = hero.get_attacker
    else
        attacker = hero
    end
    self:StartIntervalThink(1)
    damage_table = {
        victim = hero,
        attacker = attacker,
        damage = hero:GetMaxHealth() / 5,
        damage_type = DAMAGE_TYPE_PURE
    }
    ApplyDamage(damage_table)
end

function modifier_fire_trap:OnIntervalThink()
    local hero = self:GetParent()
    local attacker
    if hero.get_attacker then
        attacker = hero.get_attacker
    else
        attacker = hero
    end
    damage_table = {
        victim = hero,
        attacker = attacker,
        damage = hero:GetMaxHealth() / 5,
        damage_type = DAMAGE_TYPE_PURE
    }
    ApplyDamage(damage_table)
end
