AddItemTrigger_Periodic_EnsureUniqueTimer_Hashtable = nil
RegInit(function()
    AddItemTrigger_Periodic_EnsureUniqueTimer_Hashtable = InitHashtable()
end)

function AddAbilityCastTrigger(abilityId, abilityFunction)
    local trg = CreateTrigger()
    TriggerAddAction(trg, abilityFunction)
    TriggerAddCondition(trg , Condition(function() return GetSpellAbilityId() == FourCC(abilityId) end))
    TriggerRegisterAnyUnitEventBJ(trg , EVENT_PLAYER_UNIT_SPELL_EFFECT)
    return trg
end

function AddAbilityCastTrigger_CasterHasItem(itemId, abilityFunction)
    local trg = CreateTrigger()
    TriggerAddAction(trg, abilityFunction)
    TriggerAddCondition(trg , Condition(function() return UnitHasItemOfTypeBJ(GetSpellAbilityUnit(), itemId) end))
    TriggerRegisterAnyUnitEventBJ(trg , EVENT_PLAYER_UNIT_SPELL_EFFECT)
    return trg
end

function AddAbilityCastTrigger_Disabled(abilityId, abilityFunction)
    local trg = AddAbilityCastTrigger(abilityId, abilityFunction)
    DisableTrigger(trg)
    return trg
end

function AddDamagingEventTrigger_CasterHasAbility(abilityId, abilityFunction)
    local trg = CreateTrigger()
    TriggerAddAction(trg, abilityFunction)
    TriggerAddCondition(trg , Condition(function() return GetUnitAbilityLevel(GetEventDamageSource(), abilityId) > 0 end))
    TriggerRegisterAnyUnitEventBJ(trg , EVENT_PLAYER_UNIT_DAMAGING)
    return trg
end

function AddDamagingEventTrigger_CasterHasBuff(buffId, abilityFunction)
    local trg = CreateTrigger()
    TriggerAddAction(trg, abilityFunction)
    TriggerAddCondition(trg , Condition(function() return UnitHasBuffBJ(GetEventDamageSource(), buffId) end))
    TriggerRegisterAnyUnitEventBJ(trg , EVENT_PLAYER_UNIT_DAMAGING)
    return trg
end

function AddDamagingEventTrigger_CasterHasItem(itemId, abilityFunction)
    local trg = CreateTrigger()
    TriggerAddAction(trg, abilityFunction)
    TriggerAddCondition(trg , Condition(function() return UnitHasItemOfTypeBJ(GetEventDamageSource(), itemId) end))
    TriggerRegisterAnyUnitEventBJ(trg , EVENT_PLAYER_UNIT_DAMAGING)
    return trg
end

function AddDamagingEventTrigger_TargetHasItem(itemId, abilityFunction)
    local trg = CreateTrigger()
    TriggerAddAction(trg, abilityFunction)
    TriggerAddCondition(trg , Condition(function() return UnitHasItemOfTypeBJ(BlzGetEventDamageTarget(), itemId) end))
    TriggerRegisterAnyUnitEventBJ(trg , EVENT_PLAYER_UNIT_DAMAGING)
    return trg
end

function AddDamagingEventTrigger_TargetHasAbility(abilityId, abilityFunction)
    local trg = CreateTrigger()
    TriggerAddAction(trg, abilityFunction)
    TriggerAddCondition(trg , Condition(function() return GetUnitAbilityLevel(BlzGetEventDamageTarget(), abilityId) > 0 end))
    TriggerRegisterAnyUnitEventBJ(trg , EVENT_PLAYER_UNIT_DAMAGING)
    return trg
end

function AddDamagingEventTrigger_TargetHasBuff(buffId, abilityFunction)
    local trg = CreateTrigger()
    TriggerAddAction(trg, abilityFunction)
    TriggerAddCondition(trg , Condition(function() return UnitHasBuffBJ(BlzGetEventDamageTarget(), buffId) end))
    TriggerRegisterAnyUnitEventBJ(trg , EVENT_PLAYER_UNIT_DAMAGING)
    return trg
end

function AddDamagedEventTrigger_CasterHasAbility(abilityId, abilityFunction)
    local trg = CreateTrigger()
    TriggerAddAction(trg, abilityFunction)
    TriggerAddCondition(trg , Condition(function() return GetUnitAbilityLevel(GetEventDamageSource(), abilityId) > 0 end))
    TriggerRegisterAnyUnitEventBJ(trg , EVENT_PLAYER_UNIT_DAMAGED)
    return trg
end

function AddDamagedEventTrigger_TargetHasAbility(abilityId, abilityFunction)
    local trg = CreateTrigger()
    TriggerAddAction(trg, abilityFunction)
    TriggerAddCondition(trg , Condition(function() return GetUnitAbilityLevel(BlzGetEventDamageTarget(), abilityId) > 0 end))
    TriggerRegisterAnyUnitEventBJ(trg , EVENT_PLAYER_UNIT_DAMAGED)
    return trg
end

function AddDamagedEventTrigger_TargetHasBuff(buffId, abilityFunction)
    local trg = CreateTrigger()
    TriggerAddAction(trg, abilityFunction)
    TriggerAddCondition(trg , Condition(function() return UnitHasBuffBJ(BlzGetEventDamageTarget(), buffId) end))
    TriggerRegisterAnyUnitEventBJ(trg , EVENT_PLAYER_UNIT_DAMAGED)
    return trg
end

function AddDamagedEventTrigger_CasterHasItem(itemId, abilityFunction)
    local trg = CreateTrigger()
    TriggerAddAction(trg, abilityFunction)
    TriggerAddCondition(trg , Condition(function() return UnitHasItemOfTypeBJ(GetEventDamageSource(), itemId) end))
    TriggerRegisterAnyUnitEventBJ(trg , EVENT_PLAYER_UNIT_DAMAGED)
    return trg
end

function AddKillEventTrigger_KillerHasAbility(abilityId, abilityFunction)
    local trg = CreateTrigger()
    TriggerAddAction(trg, abilityFunction)
    TriggerAddCondition(trg, Condition(function() return GetUnitAbilityLevel(GetKillingUnit(), abilityId) > 0 end))
    TriggerRegisterAnyUnitEventBJ(trg, EVENT_PLAYER_UNIT_DEATH)
    return trg
end

function AddPeriodicPassiveAbility_CasterHasAbility(abilityId, abilityFunction)
    local trg = CreateTrigger()
    TriggerAddAction(trg, function()
        local caster = GetEnteringUnit()
        local timer = CreateTimer()
        local tick = -1
        TimerStart(timer, 1.0, true, function()
            tick = tick + 1
            if not IsUnitAliveBJ(caster) then
                DestroyTimer(timer)
                return
            end

            abilityFunction(caster, tick)
        end)
    end)
    TriggerAddCondition(trg, Condition(function() return GetUnitAbilityLevel(GetEnteringUnit(), abilityId) > 0 and GetOwningPlayer(GetEnteringUnit()) ~= Player(27) end))
    TriggerRegisterEnterRectSimple(trg, GetWorldBounds())
    return trg
end

function CreateTrigger_Periodic(interval, callback)
    local trigger = CreateTrigger()
    TriggerRegisterTimerEventPeriodic(trigger, interval)
    TriggerAddAction(trigger, callback)
    return trigger
end

function RegisterTrigger_Periodic(trigger, interval, callback)
    TriggerRegisterTimerEvent(trigger, interval, true)
    TriggerAddAction(trigger, callback)
end

function AddItemTrigger_Activate(itemId, callback)
    local trigger = CreateTrigger()
    TriggerAddCondition(trigger, Condition(function() return GetItemTypeId(GetManipulatedItem()) == itemId end))
    TriggerAddAction(trigger, callback)
    TriggerRegisterAnyUnitEventBJ(trigger, EVENT_PLAYER_UNIT_USE_ITEM)
    return trigger
end

function AddItemTrigger_Periodic(itemId, interval, callback)
    local trigger = CreateTrigger()
    TriggerAddAction(trigger, function()
        local item = GetManipulatedItem()
        local id = GetItemTypeId(item)        
        if id ~= itemId then
            return
        end

        local hero = GetManipulatingUnit()
        local heroId = GetHandleId(hero)

        local storedUnit = LoadUnitHandle(AddItemTrigger_Periodic_EnsureUniqueTimer_Hashtable, heroId, id)
        if storedUnit ~= nil then
            -- unit was loaded, this means that the a timer is already running for this item-unit combination
            return
        end

        SaveUnitHandle(AddItemTrigger_Periodic_EnsureUniqueTimer_Hashtable, heroId, id, hero)
        PeriodicCallback(interval, function()
            local hasItem = UnitHasItemOfTypeBJ(hero, itemId)
            if not hasItem then
                FlushChildHashtable(AddItemTrigger_Periodic_EnsureUniqueTimer_Hashtable, heroId)
                return true
            end

            if not IsUnitAliveBJ(hero) then
                -- if the unit is dead, no callback is needed
                return false
            end

            callback(hero)
            return false
        end)
    end)
    TriggerRegisterAnyUnitEventBJ(trigger, EVENT_PLAYER_UNIT_PICKUP_ITEM)
    return trigger
end