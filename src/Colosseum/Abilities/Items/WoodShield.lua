ItemTrigger_WoodShield_Damaging = nil

RegInit(function()
    ItemTrigger_WoodShield_Damaging = AddDamagingEventTrigger_TargetHasItem(FourCC('I00R'), ItemTrigger_WoodShield_Damaging_Actions)
end)

function ItemTrigger_WoodShield_Damaging_Actions()
    local isAttack = BlzGetEventIsAttack()    
    if not isAttack then
        return
    end

    if math.random() < 0.40 then
        local caster = BlzGetEventDamageTarget()
        local damage = GetEventDamage()
        local newDamage = math.max(0.00, damage - 25)
        BlzSetEventDamage(newDamage)
    end    
end