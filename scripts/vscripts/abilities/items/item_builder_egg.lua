--Abilities
if item_builder_egg == nil then
	item_builder_egg = class({})
end
function item_builder_egg:OnSpellStart()
	local hCaster = self:GetCaster()
	local bonus_gold = self:GetSpecialValueFor("bonus_gold")
	PlayerData:ModifyGold(hCaster:GetPlayerOwnerID(), bonus_gold, true)
	SendOverheadEventMessage(hCaster:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, hCaster, bonus_gold, nil)
	EmitSoundOnLocationWithCaster(hCaster:GetAbsOrigin(), "General.Coins", hCaster)
	self:SpendCharge()
end