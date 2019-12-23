if modifier_energy == nil then modifier_energy = class({}) end

function modifier_energy:IsHidden() return true end
function modifier_energy:IsDebuff() return false end
function modifier_energy:IsPurgable() return false end
function modifier_energy:IsPurgeException() return false end
function modifier_energy:DestroyOnExpire() return false end
function modifier_energy:RemoveOnDeath() return false end
function modifier_energy:OnCreated(params)
    local hParent = self:GetParent()
    if not hParent.energy then hParent.energy = 0 end
    self:SetDuration(-1, true)
    self:StartIntervalThink(1)
end

function modifier_energy:OnIntervalThink()
    local hParent = self:GetParent()
    if hParent.energy < 100 then
        -- 每秒生成0.5能量
        hParent.energy = hParent.energy + 0.5
        if hParent.energy >= 100 then hParent.energy = 100 end
    elseif hParent.energy >= 100 then
        hParent.energy = 100
    end
end
