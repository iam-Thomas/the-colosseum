ItemTrigger_KelensDagger = nil

RegInit(function()
    ItemTrigger_KelensDagger = AddItemTrigger_Activate(FourCC('I009'), ItemTrigger_KelensDagger_Actions)
end)

function ItemTrigger_KelensDagger_Actions()
    local caster = GetManipulatingUnit()
    MakeElusive(caster, 3.00)
end