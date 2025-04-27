AbilityTrigger_Knight_Pandemonium = nil

RegInit(function()
    local trg = AddAbilityCastTrigger('A096', AbilityTrigger_Knight_Pandemonium_Actions)
    
    RegisterTriggerEnableById(trg, FourCC('H012'))
end)

function AbilityTrigger_Knight_Pandemonium_Actions()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()

    MakeTenacious(target, 10.00)
    MakeReckless(target, 10.0)
end