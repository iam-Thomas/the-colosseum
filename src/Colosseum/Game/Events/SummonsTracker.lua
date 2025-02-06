trg_SummonTracker = nil
trg_SummonDies = nil

RegInit(function()
    trg_SummonTracker = CreateTrigger()
    TriggerAddAction(trg_SummonTracker, Trg_SummonTracker_Actions)
    TriggerRegisterAnyUnitEventBJ(trg_SummonTracker, EVENT_PLAYER_UNIT_SUMMON)

    trg_SummonDies = CreateTrigger()
    TriggerAddAction(trg_SummonTracker, Trg_SummonTracker_Die)
    TriggerRegisterAnyUnitEventBJ(trg_SummonTracker, EVENT_PLAYER_UNIT_DEATH)
end)

function Trg_SummonTracker_Actions()
    local summoner = GetSummoningUnit()
    local summoned = GetSummonedUnit()

    local id = GetHandleId(summoned)

    SaveUnitHandle(udg_Summons_HT, id, 0, summoner)
end

function Trg_SummonTracker_Die()
    local dyingUnit = GetDyingUnit()
    local id = GetHandleId(dyingUnit)
    
    local summoner = LoadUnitHandle(udg_Summons_HT, id, 0)

    if (not (summoner == nil)) then
        FlushChildHashtable(udg_Summons_HT, id)
    end
end