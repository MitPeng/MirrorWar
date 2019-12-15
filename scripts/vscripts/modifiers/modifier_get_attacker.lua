-- 获取15秒内最近攻击英雄的单位
if modifier_get_attacker == nil then modifier_get_attacker = class({}) end

function modifier_get_attacker:IsHidden() return true end
function modifier_get_attacker:IsDebuff() return false end
function modifier_get_attacker:IsPurgable() return false end
function modifier_get_attacker:IsPurgeException() return false end
function modifier_get_attacker:DestroyOnExpire() return false end
function modifier_get_attacker:RemoveOnDeath() return false end

function modifier_get_attacker:OnCreated(params)
    -- 计时用
    local hero = self:GetParent()
    hero.get_attacker_count = 0
    self:StartIntervalThink(1)
end
function modifier_get_attacker:OnIntervalThink()
    local hero = self:GetParent()
    if hero.get_attacker then
        hero.get_attacker_count = hero.get_attacker_count + 1
        if hero.get_attacker_count >= 15 then
            hero.get_attacker = nil
            hero.get_attacker_count = 0
        end
    end
end
