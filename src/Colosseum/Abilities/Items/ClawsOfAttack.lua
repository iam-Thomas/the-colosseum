ItemTrigger_ClawsOfAttack = nil

RegInit(function()
    ItemTrigger_ClawsOfAttack = AddDamagingEventTrigger_CasterHasItem(FourCC('I001'), ItemTrigger_ClawsOfAttack_Actions)
end)

function ItemTrigger_ClawsOfAttack_Actions()
    if not IsDamageType_Physical(BlzGetEventDamageType()) then
        return
    end

    local target = BlzGetEventDamageTarget()
    if not IsUnitVulnerable(target) then
        return
    end
    
    local damage = GetEventDamage()
    BlzSetEventDamage(damage * 1.15)
end