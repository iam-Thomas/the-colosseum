ItemTrigger_MagicDamageReduction = nil

RegInit(function()    
    ItemTrigger_MagicDamageReduction = CreateTrigger()
    TriggerAddAction(ItemTrigger_MagicDamageReduction, ItemTrigger_MagicDamageReduction_Actions)
    TriggerRegisterAnyUnitEventBJ(ItemTrigger_MagicDamageReduction, EVENT_PLAYER_UNIT_DAMAGING)
end)

function ItemTrigger_RunedBracers_Actions()
    local caster = GetManipulatingUnit()
    CastDummyAbilityOnTarget(caster, caster, FourCC('A06U'), 1, "antimagicshell")
end

function ItemTrigger_MagicDamageReduction_Actions()
    local isAttack = BlzGetEventIsAttack()    
    if isAttack then
        return
    end

    local damageType = BlzGetEventDamageType()
    if not IsDamageType_Magic(damageType) then
        return
    end

    local target = BlzGetEventDamageTarget()
    if not IsUnitType(target, UNIT_TYPE_HERO) then
        return
    end

    local damageFactor = 1.00

    if UnitHasItem(target, FourCC('I00N')) then
        damageFactor = damageFactor * 0.66
    elseif UnitHasItem(target, FourCC('I008')) then
        damageFactor = damageFactor * 0.75
    elseif UnitHasItem(target, FourCC('I010')) then
        damageFactor = damageFactor * 0.82
    end

    BlzSetEventDamage(GetEventDamage() * damageFactor)
end