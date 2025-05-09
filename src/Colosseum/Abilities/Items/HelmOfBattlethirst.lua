RegInit(function()
    local trg = AddItemTrigger_Activate(FourCC('I00Z'), ItemTrigger_HelmOfBattlethirst_Actions)
end)

function ItemTrigger_HelmOfBattlethirst_Actions()
    local caster = GetManipulatingUnit()
    MakeReckless(caster, 10.00)
end