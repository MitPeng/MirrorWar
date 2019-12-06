-- 双重打击平A
function double_strik_damage(keys)
    local caster = keys.caster
    local target = keys.target
    caster:PerformAttack(target, true, true, true, true, true, false, true)
end

-- 双重打击动作
function double_strik_act(keys)
    local caster = keys.caster
    caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK_STATUE, 2)
end

-- 破空动作
function break_sky_move(keys)
    local caster = keys.caster
    local target = keys.target
    local point = keys.target_points[1]
    local ability = keys.ability
    local range = ability:GetSpecialValueFor("range")
    local move_speed = ability:GetSpecialValueFor("move_speed")
    -- 获取施法者位置
    local caster_abs = caster:GetAbsOrigin()
    -- 设置施法者面向角度
    caster:SetForwardVector(((point - caster:GetOrigin()):Normalized()))
    -- 位移后的位置
    local target_point = caster_abs + range * caster:GetForwardVector()
    FindClearSpaceForUnit(caster, target_point, true)
    caster:RemoveModifierByName("modifier_phased")
end

-- 破空伤害
function break_sky_damage(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1
    local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
    damage_table = {
        victim = target,
        attacker = caster,
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL
    }
    ApplyDamage(damage_table)
end

-- 袈裟获取敏捷
function kasaya_agility(keys)
    local caster = keys.caster
    local ability = keys.ability
    -- 获取当前释放的技能
    local event_ability = keys.event_ability
    local isItem = event_ability:IsItem()
    if not isItem then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_kasaya_apply",
                                        {})
    end
end

-- 伏魔平A
function vanquish_demon_damage(keys)
    local caster = keys.caster
    local target = keys.target
    caster:PerformAttack(target, true, true, true, true, true, false, true)
end

-- 伏魔动作
function vanquish_demon_act(keys)
    local caster = keys.caster
    caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK_STATUE, 3.5)
end
