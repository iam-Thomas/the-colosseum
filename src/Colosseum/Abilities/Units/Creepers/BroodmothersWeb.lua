function BroodMother_Web_TimerCallback()
    local t = GetExpiredTimer()
    local id = GetHandleId(t) -- Get a unique ID for the timer handle
    local caster = LoadUnitHandle(udg_TimerHashtable, id, 0) -- Retrieve stored caster from hashtable
    local target = LoadUnitHandle(udg_TimerHashtable, id, 1) -- Retrieve stored target from hashtable

    if ( UnitHasBuffBJ(target, FourCC('B00A')) ) then
        CauseStun10s(caster, target)
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