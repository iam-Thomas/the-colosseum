AbilityTrigger_Sample_The_Rum = nil

RegInit(function()
    AbilityTrigger_Sample_The_Rum = AddAbilityCastTrigger('A08S', AbilityTrigger_Sample_The_Rum_Actions)
end)

function AbilityTrigger_Sample_The_Rum_Actions()
    local target = GetSpellTargetUnit()

    if (not (FourCC('o00H') == GetUnitTypeId(target))) then
        return
    end

    local caster = GetSpellAbilityUnit()
    local castPoint = GetUnitLoc(caster)

    SetUnitAnimationByIndexAfterDelay(caster, 17 , 0.05)
    
    CastDummyAbilityOnTarget(caster, caster, FourCC('A093'), 1, 'innerfire')
  
    local first = true
    local animTimer = CreateTimer()
    TimerStart(animTimer, 0.1, true, function()

        if (first) then
            AddUnitAnimationProperties(caster, "alternate", true)
            first = false
        end

        if (not UnitHasBuffBJ(caster, FourCC('B01L'))) then
            AddUnitAnimationProperties(caster, "false", true)
            DestroyTimer(animTimer)
        end
    end)

    RemoveUnit(target)

    RemoveLocation(castPoint)
    
end
