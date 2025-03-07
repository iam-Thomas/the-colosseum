AbilityTrigger_Gnoll_Claptrap = nil

RegInit(function()
    AbilityTrigger_Gnoll_Claptrap = AddAbilityCastTrigger(ClaptrapSID, AbilityTrigger_Gnoll_Claptrap_Actions)
    --FastClaptrapSID

    --AddPeriodicPassiveAbility_CasterHasAbility(abilityId, AbilityTrigger_Gnoll_Claptrap_Actions)
end)

function AbilityTrigger_Gnoll_Claptrap_Actions()
    local caster = GetSpellAbilityUnit()
    local castPoint = GetSpellTargetLoc()

    local trap = CreateUnitAtLoc(GetOwningPlayer(caster), FourCC(ClaptrapUID), castPoint, 0)
end