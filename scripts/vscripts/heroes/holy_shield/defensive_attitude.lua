function set_cd(keys)
    local caster = keys.caster
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1
    local cd = ability:GetLevelSpecialValueFor("cd", ability_level)
    ability:StartCooldown(cd)
end
