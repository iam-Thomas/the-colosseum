AbilityTrigger_BEST_UnrelentingAssault = nil

RegInit(function()
    AbilityTrigger_BEST_UnrelentingAssault = CreateTrigger()
    TriggerAddCondition(AbilityTrigger_BEST_UnrelentingAssault, Condition(function() return GetUnitAbilityLevel(GetEventDamageSource(), FourCC('A02U')) > 0 end))
    TriggerAddAction(AbilityTrigger_BEST_UnrelentingAssault, AbilityTrigger_BEST_UnrelentingAssault_Actions)
    TriggerRegisterAnyUnitEventBJ(AbilityTrigger_BEST_UnrelentingAssault, EVENT_PLAYER_UNIT_DAMAGING)
end)

function AbilityTrigger_BEST_UnrelentingAssault_Actions()
    local isAttack = BlzGetEventIsAttack()
    
    if not isAttack then
        return
    end

    local caster = GetEventDamageSource()
    local target = BlzGetEventDamageTarget()
    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A02U'))

    if UnitHasBuffBJ(caster, FourCC('B00J')) then
        local strength = GetHeroStr(caster, true)
        local mana = GetUnitState(caster, UNIT_STATE_MANA)
        local manaToBurn = math.min(20, mana)

        local bonusDamage = strength * (manaToBurn / 20)

        local damage = GetEventDamage()
        BlzSetEventDamage(damage + bonusDamage)

        SetUnitState(caster, UNIT_STATE_MANA, mana - manaToBurn)
    end
end