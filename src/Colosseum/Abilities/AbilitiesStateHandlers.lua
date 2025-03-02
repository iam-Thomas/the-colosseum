RegInit(function()
    local recklessTrigger = CreateTrigger()
    TriggerAddAction(recklessTrigger, StateHandler_Reckless)
    TriggerRegisterAnyUnitEventBJ(recklessTrigger, EVENT_PLAYER_UNIT_DAMAGING)

    local tenaciousTrigger = CreateTrigger()
    TriggerAddAction(durableTrigger, StateHandler_Tenacious)
    TriggerRegisterAnyUnitEventBJ(durableTrigger, EVENT_PLAYER_UNIT_DAMAGING)
end)

function StateHandler_Reckless()
    local source = GetEventDamageSource()
    local target = BlzGetEventDamageTarget()

    if UnitHasBuffBJ(source, FourCC('B021')) then
        BlzSetEventDamage(GetEventDamage() * 1.20)
        -- return here, so that the damage is not increased twice. buff should not stack.
        return
    end

    if UnitHasBuffBJ(target, FourCC('B021')) then
        BlzSetEventDamage(GetEventDamage() * 1.20)
    end
end

function StateHandler_Tenacious()
    local target = BlzGetEventDamageTarget()
    if UnitHasBuffBJ(target, FourCC('B01O')) then
        BlzSetEventDamage(GetEventDamage() * 0.80)
    end
end