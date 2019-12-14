function take_damage(keys)
    local hero = keys.unit
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1
    local trigger_damage = ability:GetLevelSpecialValueFor("trigger_damage",
                                                           ability_level)
    if hero.shield_counter_damage == nil then
        hero.shield_counter_damage = 0.0
    end
    local damage = keys.Damage
    hero.shield_counter_damage = hero.shield_counter_damage + damage
    if hero.shield_counter_damage >= trigger_damage then
        local abi = hero:FindAbilityByName("shield_slam")
        local level = abi:GetLevel()
        if level > 0 then abi:EndCooldown() end
        ability:ApplyDataDrivenModifier(hero, hero,
                                        "modifier_shield_counter_regain", {})
        hero.shield_counter_damage = 0
    end
end
