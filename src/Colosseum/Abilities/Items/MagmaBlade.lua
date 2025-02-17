ItemTrigger_MagmaBlade = nil

RegInit(function()
    ItemTrigger_MagmaBlade = AddDamagingEventTrigger_CasterHasItem(FourCC('I00X'), ItemTrigger_MagmaBlade_Actions)
end)

function ItemTrigger_MagmaBlade_Actions()
    local isAttack = BlzGetEventIsAttack()
    if not isAttack then
        return
    end
    
    local caster = GetEventDamageSource()
    local target = BlzGetEventDamageTarget()

    local hasBuff = UnitHasBuffBJ(target, FourCC('B018'))
    ApplyManagedBuff(target, FourCC('A086'), FourCC('B018'), 5.0, nil, nil)
    if not hasBuff then
        GrantTempArmorByBuff(target, -8, FourCC('B018'))
    end
end