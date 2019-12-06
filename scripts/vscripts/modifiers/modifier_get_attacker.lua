-- 获取15秒内最近攻击英雄的单位
if modifier_get_attacker == nil then modifier_get_attacker = class({}) end
-- 计时用
local count = 0

function modifier_get_attacker:IsHidden() return true end
function modifier_get_attacker:IsDebuff() return false end
function modifier_get_attacker:IsPurgable() return false end
function modifier_get_attacker:IsPurgeException() return false end
function modifier_get_attacker:DestroyOnExpire() return false end
function modifier_get_attacker:RemoveOnDeath() return false end

function modifier_get_attacker:DeclareFunctions()
    return {MODIFIER_EVENT_ON_ATTACKED}
end
function modifier_get_attacker:OnAttacked(params)
    local attacker = params.attacker
    local hero = self:GetParent()
    hero.get_attacker = attacker
    count = 0
end
function modifier_get_attacker:OnCreated(params) self:StartIntervalThink(1) end
function modifier_get_attacker:OnIntervalThink()
    local hero = self:GetParent()
    if hero.get_attacker then
        count = count + 1
        if count >= 15 then
            hero.get_attacker = nil
            count = 0
        end
    end
end
