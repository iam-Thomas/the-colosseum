ItemTrigger_RobeOfTheMagi = nil

RegInit(function()
    ItemTrigger_RobeOfTheMagi = AddAbilityCastTrigger_CasterHasItem(FourCC('I004'), ItemTrigger_RobeOfTheMagi_Actions)
end)

function ItemTrigger_RobeOfTheMagi_Actions()
    local caster = GetSpellAbilityUnit()
    local currentMana = GetUnitState(caster, UNIT_STATE_MANA)
    SetUnitState(caster, UNIT_STATE_MANA, currentMana + 4)
end