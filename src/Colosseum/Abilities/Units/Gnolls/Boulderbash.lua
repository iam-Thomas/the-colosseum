AbilityTrigger_Boulderbash = nil

RegInit(function()
    AbilityTrigger_Boulderbash = AddAbilityCastTrigger(BoulderbashSID, AbilityTrigger_Boulderbash_Actions)
end)

function AbilityTrigger_Boulderbash_Actions()
    local caster = GetSpellAbilityUnit()
    local casterPoint = GetUnitLoc(caster)
    local target = GetSpellTargetUnit()
    local targetPoint = GetUnitLoc(target)

    Knockback_Angled(target, AngleBetweenPoints(casterPoint, targetPoint), 550)
end