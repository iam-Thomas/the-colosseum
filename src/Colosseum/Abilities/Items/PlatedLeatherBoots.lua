ItemTrigger_PlatedLeatherBoots = nil

RegInit(function()
    ItemTrigger_PlatedLeatherBoots = AddAbilityCastTrigger('A076', ItemTrigger_PlatedLeatherBoots_Actions)
end)

function ItemTrigger_PlatedLeatherBoots_Actions()
    local caster = GetSpellAbilityUnit()
    MakeElusive(caster, 3.0)
end