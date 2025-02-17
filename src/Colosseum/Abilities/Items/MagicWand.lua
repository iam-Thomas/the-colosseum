ItemTrigger_MagicWand = nil

RegInit(function()
    ItemTrigger_MagicWand = AddDamagingEventTrigger_CasterHasItem(FourCC('I006'), ItemTrigger_MagicWand_Actions)
end)

function ItemTrigger_MagicWand_Actions(hero)
    local isAttack = BlzGetEventIsAttack()    
    if not isAttack then
        return
    end
    
    local damage = GetEventDamage()
    BlzSetEventDamage(damage * 0.6)
end