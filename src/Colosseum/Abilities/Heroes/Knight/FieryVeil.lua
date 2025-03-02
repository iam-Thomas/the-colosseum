--AbilityTrigger_Knight_FieryVeil = nil

RegInit(function()
    local trg = AddAbilityCastTrigger('A09X', AbilityTrigger_Knight_FieryVeil_Actions)
end)

function AbilityTrigger_Knight_FieryVeil_Actions()
    local caster = GetSpellAbilityUnit()
    local abilityLevel = GetUnitAbilityLevel(caster, FourCC('A09X'))

    --ApplyManagedBuff(caster, FourCC('S00B'), FourCC('B020'), 12, nil, nil)
    local effect = CreateEffectOnUnitByBuff("origin", caster, "war3mapImported\\Infernal_Bulwark.mdx", FourCC('B020'))
    BlzSetSpecialEffectScale(effect, 0.7)
    CastDummyAbilityOnTarget(caster, caster, FourCC('A09Y'), abilityLevel, "antimagicshell", 2.0)
end