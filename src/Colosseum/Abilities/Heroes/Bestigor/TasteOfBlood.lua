AbilityTrigger_BEST_TasteOfBlood = nil
AbilityTrigger_BEST_TasteOfBlood_Damaging = nil
AbilityTrigger_BEST_TasteOfBlood_Damaged = nil

RegInit(function()
    AbilityTrigger_BEST_TasteOfBlood = AddAbilityCastTrigger('A07N', AbilityTrigger_BEST_TasteOfBlood_Actions)
    AbilityTrigger_BEST_TasteOfBlood_Damaging = AddDamagingEventTrigger_CasterHasAbility(FourCC('A07N'), AbilityTrigger_BEST_TasteOfBlood_Damaging_Actions)
    AbilityTrigger_BEST_TasteOfBlood_Damaged = AddDamagedEventTrigger_CasterHasAbility(FourCC('A07N'), AbilityTrigger_BEST_TasteOfBlood_Damaged_Actions)
end)

function AbilityTrigger_BEST_TasteOfBlood_Actions()
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

function AbilityTrigger_BEST_TasteOfBlood_Damaging_Actions()
    local isAttack = BlzGetEventIsAttack()    
    if isAttack then
        return
    end

    local damageType = BlzGetEventDamageType()
    if damageType ~= DAMAGE_TYPE_NORMAL then
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

function AbilityTrigger_BEST_TasteOfBlood_Damaged_Actions()
    local isAttack = BlzGetEventIsAttack()    
    if isAttack then
        return
    end

    local damageType = BlzGetEventDamageType()
    if damageType ~= DAMAGE_TYPE_NORMAL then
        return
    end

    local caster = GetEventDamageSource()
    local target = BlzGetEventDamageTarget()
    local targetLoc = GetUnitLoc(target)
    local damage = GetEventDamage()

    local projectile = FireHomingProjectile_PointToUnit(targetLoc, caster, "war3mapImported\\Windwalk Blood.mdl", 300.00, 0.11, function()
        RemoveLocation(targetLoc)
        CauseHealUnscaled(caster, caster, damage * 0.40)
    end)

    local effect = projectile.projectileEffect
    BlzSetSpecialEffectScale(effect, 0.35)    
end