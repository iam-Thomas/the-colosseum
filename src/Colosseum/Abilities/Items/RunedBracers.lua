ItemTrigger_RunedBracers = nil
ItemTrigger_RunedBracers_Damaging = nil

RegInit(function()
    ItemTrigger_RunedBracers = AddItemTrigger_Activate(FourCC('I00N'), ItemTrigger_RunedBracers_Actions)
    ItemTrigger_RunedBracers_Damaging = AddDamagingEventTrigger_TargetHasItem(FourCC('I00N'), ItemTrigger_RunedBracers_Damaging_Actions)
end)

function ItemTrigger_RunedBracers_Actions()
    local caster = GetManipulatingUnit()
    CastDummyAbilityOnTarget(caster, caster, FourCC('A06U'), 1, "antimagicshell")
end

function ItemTrigger_RunedBracers_Damaging_Actions()
    local isAttack = BlzGetEventIsAttack()    
    if isAttack then
        return
    end

    local damageType = BlzGetEventDamageType()
    if damageType == DAMAGE_TYPE_DEFENSIVE then
        return
    end

    BlzSetEventDamage(GetEventDamage() * 0.66)
end