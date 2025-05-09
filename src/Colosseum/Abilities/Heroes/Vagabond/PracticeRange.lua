RegInit(function()
    local trigger = AddAbilityCastTrigger('A00O', AbilityTrigger_Vagabond_PracticeRange)
    
    RegisterTriggerEnableById(trigger, FourCC('H00U'))
end)

function AbilityTrigger_Vagabond_PracticeRange()
    local caster = GetSpellAbilityUnit()
    BlzStartUnitAbilityCooldown(caster, FourCC('A03G'), 0.1)
    BlzStartUnitAbilityCooldown(caster, FourCC('A03D'), 0.1)

    ApplyManagedBuff(caster, FourCC('S00E'), FourCC('B026'), 20.00, nil, nil)

    SetRoundCooldown_R(caster, 1)
end