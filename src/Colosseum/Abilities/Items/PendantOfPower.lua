ItemTrigger_PendantOfPower = nil

RegInit(function()
    ItemTrigger_PendantOfPower = AddItemTrigger_Activate(FourCC('I00F'), ItemTrigger_PendantOfPower_Actions)
end)

function ItemTrigger_PendantOfPower_Actions()
    local caster = GetManipulatingUnit()
    MakeEmpowered(caster, 12)
end