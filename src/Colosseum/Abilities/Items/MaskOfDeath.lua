ItemTrigger_MaskOfDeath = nil

RegInit(function()
    ItemTrigger_MaskOfDeath = AddDamagedEventTrigger_CasterHasItem(FourCC('I00Y'), ItemTrigger_MaskOfDeath_Actions)
end)

function ItemTrigger_MaskOfDeath_Actions()    
    local caster = GetEventDamageSource()
    local damage = GetEventDamage()
    CauseHealUnscaled(caster, caster, damage * 0.04)
end