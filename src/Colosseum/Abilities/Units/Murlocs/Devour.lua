AbilityTrigger_Murloc_Devour = nil

RegInit(function()
    AbilityTrigger_Murloc_Devour = AddAbilityCastTrigger('A08E', AbilityTrigger_Murloc_Devour_Actions)
end)

function AbilityTrigger_Murloc_Devour_Actions()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()

    local lifePercentHealing = 10.00
    
    SetUnitExploded(target, true)
    KillUnit(target)

    local lifePercent = GetUnitLifePercent(caster)
    local targetLifePercent = math.min(100.00, lifePercent + lifePercentHealing)
    SetUnitLifePercentBJ(caster, targetLifePercent)

    local baseDamage = BlzGetUnitBaseDamage(caster, 0)
    local lifeTotal = GetUnitState(caster, UNIT_STATE_MAX_LIFE)
    local bonusDamage = math.floor((lifeTotal * 0.01) + 0.5)
    BlzSetUnitBaseDamage(caster, baseDamage + bonusDamage, 0)
end