GameBalanceTrigger_ScalingHashtable = nil
GameBalanceTrigger_UnitSpawned = nil
GameBalanceTrigger_Damaging = nil

RegInit(function()
    GameBalanceTrigger_ScalingHashtable = InitHashtable()

    -- Initialize the trigger
    GameBalanceTrigger_UnitSpawned = CreateTrigger()
    TriggerAddAction(GameBalanceTrigger_UnitSpawned, GameBalanceTrigger_UnitSpawned_Function)
    TriggerRegisterEnterRectSimple(GameBalanceTrigger_UnitSpawned, GetEntireMapRect())

    GameBalanceTrigger_Damaging = CreateTrigger()
    TriggerAddAction(GameBalanceTrigger_Damaging, GameBalanceTrigger_Damaging_Function)
    TriggerRegisterAnyUnitEventBJ(GameBalanceTrigger_Damaging , EVENT_PLAYER_UNIT_DAMAGING)
end)

function GameBalanceTrigger_UnitSpawned_Function()
    local unit = GetEnteringUnit()

    if IsUnitType(unit, UNIT_TYPE_HERO) then
        return
    end

    local id = GetHandleId(GetOwningPlayer(unit))
    local hpScaling = LoadReal(GameBalanceTrigger_ScalingHashtable, id, 0)
    local damageScaling = LoadReal(GameBalanceTrigger_ScalingHashtable, id, 1)

    local hp = BlzGetUnitMaxHP(unit)
    BlzSetUnitMaxHP(unit, math.ceil(hp * (1.00 + hpScaling)))
    SetUnitLifePercentBJ(unit, 100)

    local dmg = BlzGetUnitBaseDamage(unit, 0)
    BlzSetUnitBaseDamage(unit, math.ceil(dmg * (1.00 + damageScaling)), 0)
end

function GameBalanceTrigger_Damaging_Function()
    local isAttack = BlzGetEventIsAttack()    
    if isAttack then
        return
    end

    local source = GetEventDamageSource()
    --local target = GetEventDamageTarget()
    local amount = GetEventDamage()

    if IsUnitType(source, UNIT_TYPE_HERO) then
        return
    end


    local id = GetHandleId(GetOwningPlayer(source))
    local damageScaling = LoadReal(GameBalanceTrigger_ScalingHashtable, id, 2)

    BlzSetEventDamage(amount * (1.00 + damageScaling))
end

function GameBalanceTrigger_SetScaling(player, hpScaling, damageScaling, spellScaling)
    local id = GetHandleId(player)
    SaveReal(GameBalanceTrigger_ScalingHashtable, id, 0, hpScaling)
    SaveReal(GameBalanceTrigger_ScalingHashtable, id, 1, damageScaling)
    SaveReal(GameBalanceTrigger_ScalingHashtable, id, 2, spellScaling)
end

function GameBalanceTrigger_AddScaling(player, hpScaling, damageScaling, spellScaling)
    local id = GetHandleId(player)
    local hp = LoadReal(GameBalanceTrigger_ScalingHashtable, id, 0)
    local damage = LoadReal(GameBalanceTrigger_ScalingHashtable, id, 1)
    local spells = LoadReal(GameBalanceTrigger_ScalingHashtable, id, 2)

    SaveReal(GameBalanceTrigger_ScalingHashtable, id, 0, hp + hpScaling)
    SaveReal(GameBalanceTrigger_ScalingHashtable, id, 1, damage + damageScaling)
    SaveReal(GameBalanceTrigger_ScalingHashtable, id, 2, spells + spellScaling)
end