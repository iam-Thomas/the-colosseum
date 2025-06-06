AbilityTrigger_BEST_Sunder = nil

RegInit(function()
    AbilityTrigger_BEST_Sunder = AddAbilityCastTrigger('A02T', AbilityTrigger_BEST_Sunder_Actions)
    
    RegisterTriggerEnableById(AbilityTrigger_BEST_Sunder, FourCC('O004'))
end)

function AbilityTrigger_BEST_Sunder_Actions()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()

    GrantTempArmor(target, -12, 8)
    CauseForceDamage(caster, target, 40)
end