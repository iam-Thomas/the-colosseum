AbilityTrigger_BM_MirrorImage = nil

RegInit(function()
    AbilityTrigger_BM_MirrorImage = AddAbilityCastTrigger('A003', AbilityTrigger_BM_MirrorImage_Actions)
end)

function AbilityTrigger_BM_MirrorImage_Actions()
    local caster = GetSpellAbilityUnit()
    MakeElusive(caster, 5.00)
end