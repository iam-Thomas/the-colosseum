Warden_AnimatedShadowHashtable = nil

RegInit(function()
    Warden_AnimatedShadowHashtable = InitHashtable()

    local shadowDieTrigger = CreateTrigger()
    TriggerAddAction(shadowDieTrigger, Warden_AnimatedShadow_Die)
    TriggerAddCondition(shadowDieTrigger, Condition(function()
        return GetUnitTypeId(GetDyingUnit()) == FourCC('e003')
    end))
    TriggerRegisterAnyUnitEventBJ(shadowDieTrigger, EVENT_PLAYER_UNIT_DEATH)
    
    RegisterTriggerEnableById(shadowDieTrigger, FourCC('E002'))
end)

function Warden_AnimatedShadow_Die()
    local id = GetHandleId(GetDyingUnit())
    FlushChildHashtable(Warden_AnimatedShadowHashtable, id)
end

function Warden_SummonAnimatedShadow_AtCasterLoc(caster, duration)
    local point = GetUnitLoc(caster)
    local facing = GetUnitFacing(caster)
    local unit = Warden_SummonAnimatedShadow(caster, point, duration, facing)
    RemoveLocation(point)
    return unit
end

function Warden_SummonAnimatedShadow(caster, point, duration, facing)
    local locFinal = GetUnitValidLoc(point)
    local life = Warden_GetDefaultAnimatedShadowLife(caster)
    local damage = Warden_GetDefaultAnimatedShadowDamage(caster)
    local unit = CreateUnitAtLoc(GetOwningPlayer(caster), FourCC('e003'), locFinal, facing)
    local id = GetHandleId(unit)
    SaveUnitHandle(Warden_AnimatedShadowHashtable, id, 0, caster)
    
    UnitApplyTimedLife(unit, FourCC('BTLF'), duration)

    BlzSetUnitMaxHP(unit, life)
    SetUnitLifePercentBJ(unit, 100.00)
    BlzSetUnitBaseDamage(unit, math.floor(damage + 0.5), 0)
    RemoveLocation(locFinal)
    return unit
end

function Warden_GetAnimatedShadowSummoner(unit)
    local id = GetHandleId(unit)
    return LoadUnitHandle(Warden_AnimatedShadowHashtable, id, 0)
end

function Warden_GetDefaultAnimatedShadowLife(caster)
    local life = GetUnitState(caster, UNIT_STATE_MAX_LIFE)
    return life * 0.1
end

function Warden_GetDefaultAnimatedShadowDamage(caster)
    local damage = GetHeroDamageTotal(caster)
    return damage * 0.2
end

function Warden_GetLocBehindTarget(target)
    local unitLoc = GetUnitLoc(target)
    local facing = GetUnitFacing(target)
    local loc = PolarProjectionBJ(unitLoc, 120, facing + 180)
    RemoveLocation(unitLoc)
    return loc
end

function Warden_GetFacingTowardsTarget(fromPoint, target)
    local targetLoc = GetUnitLoc(target)
    local angle = AngleBetweenPoints(fromPoint, targetLoc)
    RemoveLocation(targetLoc)
    return angle
end