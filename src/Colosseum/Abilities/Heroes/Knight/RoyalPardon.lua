AbilityTrigger_Knight_RoyalPardon = nil

RegInit(function()
    local trg = AddAbilityCastTrigger('A096', AbilityTrigger_Knight_RoyalPardon_Actions)
end)

function AbilityTrigger_Knight_RoyalPardon_Actions()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()

    MakeElusive(target, 4.00)
    MakeTenacious(target, 10.00)
end