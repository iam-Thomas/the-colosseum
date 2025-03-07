RegInit(function()
    AddAbilityCastTrigger('A03D', AbilityTrigger_Vagabond_Bushwalk)
end)

function AbilityTrigger_Vagabond_Bushwalk()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()

    MakeElusive(caster, 5.0)
    MakeElusive(target, 5.0)

    RemoveLocation(casterLoc)
    RemoveLocation(targetLoc)
end