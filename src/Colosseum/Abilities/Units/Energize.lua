AbilityTrigger_Generic_Energize_Damaging = nil

RegInit(function()
    AbilityTrigger_Generic_Energize_Damaging = AddDamagingEventTrigger_CasterHasAbility(FourCC('A07P'), AbilityTrigger_Generic_Energize_Damaging_Actions)
end)

function AbilityTrigger_Generic_Energize_Damaging_Actions()
    local isAttack = BlzGetEventIsAttack()
    if not isAttack then
        return
    end

    local caster = GetEventDamageSource()
    local target = BlzGetEventDamageTarget()
    if not IsUnitEnemy(caster, GetOwningPlayer(target)) then
        return
    end

    local mana = GetUnitState(caster, UNIT_STATE_MANA)
    SetUnitState(caster, UNIT_STATE_MANA, mana + 10)
end