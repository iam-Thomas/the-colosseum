RegInit(function()
    local trg = AddAbilityCastTrigger('A03D', AbilityTrigger_Vagabond_Bushwalk)
    
    RegisterTriggerEnableById(trg, FourCC('H00U'))
end)

function AbilityTrigger_Vagabond_Bushwalk()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()

    MakeElusive(caster, 5.0)
    MakeElusive(target, 5.0)

    RemoveLocation(casterLoc)
    RemoveLocation(targetLoc)
end