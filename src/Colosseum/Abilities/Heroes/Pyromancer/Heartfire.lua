AbilityTrigger_Pyro_Heartfire_Two = nil

RegInit(function()
    AbilityTrigger_Pyro_Heartfire_Two = AddAbilityCastTrigger('A03P', AbilityTrigger_Pyro_Heartfire_Two_Actions)
end)

function AbilityTrigger_Pyro_Heartfire_Two_Actions()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()

    local duration = 14.00

    ApplyManagedBuff_Magic(target, FourCC('A03R'), FourCC('B00R'), duration, "origin", "Abilities\\Spells\\NightElf\\Immolation\\ImmolationTarget.mdl")
end