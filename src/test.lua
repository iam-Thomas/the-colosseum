TriggerEnablerTable = {}

function RegisterTriggerEnableById(trigger, id)
    table.insert(TriggerEnablerTable, {trigger = trigger, id = id})
    DisableTrigger(trigger)
end

function EnableTriggerById(id)
    for _, v in ipairs(TriggerEnablerTable) do
        if v.id == id then
            EnableTrigger(v.trigger)
            return
        end
    end
end

function DisableTriggerById(id)
    for _, v in ipairs(TriggerEnablerTable) do
        if v.id == id then
            DisableTrigger(v.trigger)
            return
        end
    end
end