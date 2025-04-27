InitFunctions = {}

function InitLua()
    --SetMapFlag(MAP_LOCK_RESOURCE_TRADING, true)
    for _, func in ipairs(InitFunctions) do
        func()
    end
end

function RegInit(func)
    table.insert(InitFunctions, func)
end

TriggerEnablerTable = {}

function RegisterTriggerEnableById(trigger, id)
    table.insert(TriggerEnablerTable, {trigger = trigger, id = id})
    DisableTrigger(trigger)
end

function EnableTriggerById(id)
    for _, v in ipairs(TriggerEnablerTable) do
        if v.id == id then
            EnableTrigger(v.trigger)
        end
    end
end

function DisableTriggerById(id)
    for _, v in ipairs(TriggerEnablerTable) do
        if v.id == id then
            DisableTrigger(v.trigger)
        end
    end
end