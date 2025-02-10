AbilityTrigger_BM_WindWalk = nil

RegInit(function()
    AbilityTrigger_BM_WindWalk = AddAbilityCastTrigger('A002', AbilityTrigger_BM_WindWalk_Actions)
end)

function AbilityTrigger_BM_WindWalk_Actions()
    local caster = GetSpellAbilityUnit()
    MakeElusive(caster, 5.00)
end