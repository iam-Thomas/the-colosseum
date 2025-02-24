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

    SetUnitAnimationByIndexAfterDelay(caster, 17 , 0.05)
    
    CastDummyAbilityOnTarget(caster, caster, FourCC('A093'), 1, 'innerfire')

    -- If the caster already has the buff, skip the timer
    if (not UnitHasBuffBJ(caster, FourCC('B01L'))) then
        AddUnitAnimationProperties(caster, "alternate", true)
    
        local animTimer = CreateTimer()
        local index = 0
        TimerStart(animTimer, 0.1, true, function()
            index = index + 1
    
            if (not UnitHasBuffBJ(caster, FourCC('B01L'))) then
                AddUnitAnimationProperties(caster, "false", true)
                DestroyTimer(animTimer)
            end
    
            if index >= 10 then
                CauseHeal(caster, target, 20)
                index = 0
            end
        end)
    end
    
    -- TODO: Check if removing the unit will work properly with gameloop triggers
    RemoveUnit(target)
end
