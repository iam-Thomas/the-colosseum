AbilitiesCommonCleanupTrigger_UnitDied = nil

RegInit(function()
    -- Create a trigger to cleanup the managed buffs hashtable when a unit dies
    AbilitiesCommonCleanupTrigger_UnitDied = CreateTrigger()
    TriggerAddAction(AbilitiesCommonCleanupTrigger_UnitDied, AbilitiesCommonCleanupTrigger_UnitDied_Actions)
    TriggerRegisterAnyUnitEventBJ(AbilitiesCommonCleanupTrigger_UnitDied, EVENT_PLAYER_UNIT_DEATH)
end)

function AbilitiesCommonCleanupTrigger_UnitDied_Actions()
    local unit = GetDyingUnit()
    local id = GetHandleId(unit)
    FlushChildHashtable(ManagedBuffHashtable, id)
end