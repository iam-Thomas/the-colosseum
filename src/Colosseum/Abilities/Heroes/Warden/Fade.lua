RegInit(function()
    local trig = AddAbilityCastTrigger('A002', AbilityTrigger_Warden_Fade)
end)

function AbilityTrigger_Warden_Fade()
    local caster = GetSpellAbilityUnit()
    MakeElusive(caster, 3.00)
    Warden_SummonAnimatedShadow_AtCasterLoc(caster, 6.00)
end
