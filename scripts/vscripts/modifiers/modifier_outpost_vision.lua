if modifier_outpost_vision == nil then modifier_outpost_vision = class({}) end

function modifier_outpost_vision:IsHidden() return true end
function modifier_outpost_vision:IsDebuff() return false end
function modifier_outpost_vision:IsPurgable() return false end
function modifier_outpost_vision:IsPurgeException() return false end
function modifier_outpost_vision:DestroyOnExpire() return false end
function modifier_outpost_vision:RemoveOnDeath() return false end

function modifier_outpost_vision:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BONUS_DAY_VISION, MODIFIER_PROPERTY_BONUS_NIGHT_VISION
    }
    return funcs
end
function modifier_outpost_vision:GetBonusDayVision() return 800 end
function modifier_outpost_vision:GetBonusNightVision() return 800 end
