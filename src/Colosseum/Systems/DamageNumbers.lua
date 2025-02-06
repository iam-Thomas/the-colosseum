CombatEventTrigger_DamageNumbers = nil

RegInit(function()
    CombatEventTrigger_DamageNumbers = CreateTrigger()
    TriggerAddAction(CombatEventTrigger_DamageNumbers, CombatEventTrigger_DamageNumbers_Actions)
    TriggerRegisterAnyUnitEventBJ(CombatEventTrigger_DamageNumbers, EVENT_PLAYER_UNIT_DAMAGED)
end)

function CombatEventTrigger_DamageNumbers_Actions()
    local source = GetEventDamageSource()
    local target = BlzGetEventDamageTarget()
    local damage = GetEventDamage()

    DamageMeter_AddDamage(source, target, damage)

    if (damage < 1.00) then
        return
    end

    local text = math.floor(damage)
    local point = GetUnitLoc(target)
    local x = GetLocationX(point) + (math.random() * 2 - 1) * 15
    local y = GetLocationY(point) + (math.random() * 2 - 1) * 15
    local z = GetLocationZ(point)

    local floatingText = CreateTextTag()
    SetTextTagTextBJ(floatingText, text, 8)
    SetTextTagPos(floatingText, x, y, z)
    SetTextTagColor(floatingText, 255, 255, 255, 255)
    SetTextTagPermanent(floatingText, false)
    SetTextTagLifespan(floatingText, 1.11)
    SetTextTagVelocity(floatingText, 0.0, 0.03)
    SetTextTagVisibility(floatingText, true)

    RemoveLocation(point)
end