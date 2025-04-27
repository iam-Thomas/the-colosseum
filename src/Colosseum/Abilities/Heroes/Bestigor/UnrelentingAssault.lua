AbilityTrigger_BEST_UnrelentingAssault = nil

RegInit(function()
    AbilityTrigger_BEST_UnrelentingAssault = CreateTrigger()
    TriggerAddCondition(AbilityTrigger_BEST_UnrelentingAssault, Condition(function() return GetUnitAbilityLevel(GetEventDamageSource(), FourCC('A02U')) > 0 end))
    TriggerAddAction(AbilityTrigger_BEST_UnrelentingAssault, AbilityTrigger_BEST_UnrelentingAssault_Actions)
    TriggerRegisterAnyUnitEventBJ(AbilityTrigger_BEST_UnrelentingAssault, EVENT_PLAYER_UNIT_DAMAGING)
    
    RegisterTriggerEnableById(AbilityTrigger_BEST_UnrelentingAssault, FourCC('O004'))
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
        local mana = GetUnitState(caster, UNIT_STATE_MANA)
        local manaToBurn = math.min(20, mana)
        local bonusDamageManaFactor = (manaToBurn / 20)
        local baseDamage = 15.00 + (5.00 * abilityLevel)
        local dmgFactor = 0.12 + (0.04 * abilityLevel)

        local damage = GetEventDamage()
        local bonusDamage = ((damage * dmgFactor) + baseDamage) * bonusDamageManaFactor

        BlzSetEventDamage(damage + bonusDamage)

        if UnitHasBuffBJ(caster, FourCC('B01A')) then
            return
        end
        SetUnitState(caster, UNIT_STATE_MANA, mana - manaToBurn)
    end
end