ItemTrigger_OrbOfShadow = nil
ItemTrigger_OrbOfShadow_Damaged = nil

RegInit(function()
    ItemTrigger_OrbOfShadow = AddDamagingEventTrigger_CasterHasItem(FourCC('I00E'), ItemTrigger_OrbOfShadow_Actions)
    ItemTrigger_OrbOfShadow_Damaged = AddDamagedEventTrigger_CasterHasItem(FourCC('I00E'), ItemTrigger_OrbOfShadow_Damaged_Actions)
end)

function ItemTrigger_OrbOfShadow_Actions()
    local isAttack = BlzGetEventIsAttack()    
    if not isAttack then
        return
    end

    local caster = GetEventDamageSource()
    local target = BlzGetEventDamageTarget()    
end

function ItemTrigger_OrbOfShadow_Damaged_Actions()
    local damageType = BlzGetEventDamageType()
    if damageType == DAMAGE_TYPE_DEFENSIVE then
        return
    end
    
    local damage = GetEventDamage()
    if damage < 1.00 then
        return
    end

    local caster = GetEventDamageSource()
    local heroLevel = GetHeroLevel(caster)
    local bonusDamage = 4.0 + (heroLevel * 0.2)
    damage = damage + bonusDamage
    BlzSetEventDamage(damage)
end