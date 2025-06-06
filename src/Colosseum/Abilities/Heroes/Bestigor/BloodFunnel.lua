AbilityTrigger_BEST_BloodFunnel = nil
AbilityTrigger_BEST_BloodFunnel_Damaging = nil
AbilityTrigger_BEST_BloodFunnel_Damaged = nil

RegInit(function()
    AbilityTrigger_BEST_BloodFunnel = AddAbilityCastTrigger('A07N', AbilityTrigger_BEST_BloodFunnel_Actions)
    AbilityTrigger_BEST_BloodFunnel_Damaging = AddDamagingEventTrigger_CasterHasAbility(FourCC('A07N'), AbilityTrigger_BEST_BloodFunnel_Damaging_Actions)
    AbilityTrigger_BEST_BloodFunnel_Damaged = AddDamagedEventTrigger_CasterHasAbility(FourCC('A07N'), AbilityTrigger_BEST_BloodFunnel_Damaged_Actions)

    RegisterTriggerEnableById(AbilityTrigger_BEST_BloodFunnel, FourCC('O004'))
    RegisterTriggerEnableById(AbilityTrigger_BEST_BloodFunnel_Damaging, FourCC('O004'))
    RegisterTriggerEnableById(AbilityTrigger_BEST_BloodFunnel_Damaged, FourCC('O004'))
end)

function AbilityTrigger_BEST_BloodFunnel_Actions()
    --A07O
    --B014
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()
    local casterLoc = GetUnitLoc(caster)
    
    FireHomingProjectile_PointToUnit(casterLoc, target, "war3mapImported\\Windwalk Blood.mdl", 550, 0.32, function()
        RemoveLocation(casterLoc)
        ApplyManagedBuff_Magic(target, FourCC('A07O'), FourCC('B014'), 10.00, "origin", "war3mapImported\\Windwalk Blood.mdl")

        -- extend deep wounds effect
        local deepWoundsTargetId = GetHandleId(target)
        local storedDeepWoundsCaster = LoadUnitHandle(AbilityTrigger_BEST_Deep_Wounds_Hashtable, deepWoundsTargetId, 0)
        if storedDeepWoundsCaster ~= nil then
            SaveInteger(AbilityTrigger_BEST_Deep_Wounds_Hashtable, deepWoundsTargetId, 2, 10)
        end
    end)
end

function AbilityTrigger_BEST_BloodFunnel_Damaging_Actions()
    local isAttack = BlzGetEventIsAttack()    
    if isAttack then
        return
    end

    local damageType = BlzGetEventDamageType()
    if damageType ~= DAMAGE_TYPE_ENHANCED then
        return
    end
    
    
    local target = BlzGetEventDamageTarget()
    if not UnitHasBuffBJ(target, FourCC('B014')) then
        return
    end

    local abilityLevel = GetUnitAbilityLevel(GetEventDamageSource(), FourCC('A07N'))
    local factor = 1.6 + (0.1) * abilityLevel
    local bonusDamage = 9 + (1 * abilityLevel)
    local damage = GetEventDamage()
    BlzSetEventDamage(damage * factor + bonusDamage)
end

function AbilityTrigger_BEST_BloodFunnel_Damaged_Actions()
    local isAttack = BlzGetEventIsAttack()    
    if isAttack then
        return
    end

    local damageType = BlzGetEventDamageType()
    if damageType ~= DAMAGE_TYPE_ENHANCED then
        return
    end

    local caster = GetEventDamageSource()
    local target = BlzGetEventDamageTarget()
    local targetLoc = GetUnitLoc(target)
    local damage = GetEventDamage()

    local projectile = FireHomingProjectile_PointToUnit(targetLoc, caster, "war3mapImported\\Windwalk Blood.mdl", 450.00, 0.11, function()
        RemoveLocation(targetLoc)
        local healFactor = 1.0
        if UnitHasBuffBJ(caster, FourCC('B01A')) then
            healFactor = 3.0
        end
        CauseHealUnscaled(caster, caster, damage * 0.40 * healFactor)
    end)

    local effect = projectile.projectileEffect
    BlzSetSpecialEffectScale(effect, 0.35)    
end