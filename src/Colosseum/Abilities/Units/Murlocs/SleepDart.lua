AbilityTrigger_Murloc_SleepDart = nil

RegInit(function()
    AbilityTrigger_Murloc_SleepDart = AddAbilityCastTrigger('A07T', AbilityTrigger_Murloc_SleepDart_Actions)
end)

function AbilityTrigger_Murloc_SleepDart_Actions()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()
    local startPoint = GetUnitLoc(caster)

    FireHomingProjectile_PointToUnit(startPoint, target, "Abilities\\Weapons\\PoisonArrow\\PoisonArrowMissile.mdl", 700, 0.11, function()
        RemoveLocation(startPoint)
        CastDummyAbilityOnTarget(caster, target, FourCC('A07U'), 1, "sleep")
    end)
end