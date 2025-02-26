AbilityTrigger_Knight_LawBreaker = nil

RegInit(function()
    local trg = AddAbilityCastTrigger('A096', AbilityTrigger_Knight_LawBreaker_Actions)
end)

function AbilityTrigger_Knight_LawBreaker_Actions()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()

    MakeElusive(target, 6.00)
    MakeTenacious(target, 10.00)
end