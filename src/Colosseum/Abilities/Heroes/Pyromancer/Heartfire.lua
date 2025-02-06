AbilityTrigger_Pyro_Heartfire_Two = nil

RegInit(function()
    AbilityTrigger_Pyro_Heartfire_Two = AddAbilityCastTrigger('A03P', AbilityTrigger_Pyro_Heartfire_Two_Actions)
end)

function AbilityTrigger_Pyro_Heartfire_Two_Actions()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()

    local duration = 5.00 + (3.00 * GetUnitAbilityLevel(caster, FourCC('A03P')))

    ApplyManagedBuff(target, FourCC('A03R'), FourCC('B00R'), duration, "origin", "Abilities\\Spells\\NightElf\\Immolation\\ImmolationTarget.mdl")
end