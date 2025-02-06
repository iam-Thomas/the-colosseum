function BroodMother_Web_TimerCallback()
    local t = GetExpiredTimer()
    local id = GetHandleId(t) -- Get a unique ID for the timer handle
    local caster = LoadUnitHandle(udg_TimerHashtable, id, 0) -- Retrieve stored caster from hashtable
    local target = LoadUnitHandle(udg_TimerHashtable, id, 1) -- Retrieve stored target from hashtable

    if ( UnitHasBuffBJ(target, FourCC('B00A')) ) then
        udg_DummyOwner = GetOwningPlayer(caster)
        udg_DummyPoint = GetUnitLoc(target)
        udg_DummySkill = FourCC('A01I')
        udg_DummySkillLevel = 1
        udg_DummyDuration = 2.00
        udg_DummyOrderString = "thunderbolt"
        udg_DummyCastType = "unit"
        udg_DummyTargetUnit = target
        ConditionalTriggerExecute( gg_trg_Dummy_Start )
        AddSpecialEffectTargetUnitBJ( "chest", target, "Abilities\\Spells\\Undead\\Web\\Web_AirTarget.mdl" )
        udg_SFXDurationArg = 10.00
        TriggerExecute( gg_trg_SFX_Cleanup )
    end

    -- Clean up
    RemoveSavedHandle(udg_TimerHashtable, id, 0) -- Clean up caster in hashtable
    RemoveSavedHandle(udg_TimerHashtable, id, 1) -- Clean up target in hashtable
    DestroyTimer(t)
    caster = null
    target = null
end

function Trig_BroodMother_Web_Actions()
    local caster = GetTriggerUnit()
    local target = GetSpellTargetUnit()
    local time = 5.00
    local t = CreateTimer()
    local id = GetHandleId(t) -- Get a unique ID for the timer handle

    SaveUnitHandle(udg_TimerHashtable, id, 0, caster)
    SaveUnitHandle(udg_TimerHashtable, id, 1, target)

    TimerStart(t, time, false, function() BroodMother_Web_TimerCallback() end)
    
    -- Clean up
    caster = null
    target = null
end

trg_BroodMother_Web = nil
RegInit(function()
    trg_BroodMother_Web = AddAbilityCastTrigger('A01H', Trig_BroodMother_Web_Actions)
end)