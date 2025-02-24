ItemTrigger_RunedBracers = nil
ItemTrigger_RunedBracers_Damaging = nil

RegInit(function()
    ItemTrigger_RunedBracers = AddItemTrigger_Activate(FourCC('I00N'), ItemTrigger_RunedBracers_Actions)
end)

function ItemTrigger_RunedBracers_Actions()
    local caster = GetManipulatingUnit()
    CastDummyAbilityOnTarget(caster, caster, FourCC('A06U'), 1, "antimagicshell")
end

-- magic damage reduction trigger handled in Common.MagicDamageResist.lua