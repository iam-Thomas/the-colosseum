AbilityTrigger_Pyro_Heartfire_Damaged_Healing = nil

RegInit(function()
    AbilityTrigger_Pyro_Heartfire_Damaged_Healing = AddDamagedEventTrigger_TargetHasBuff(FourCC('B00R'), AbilityTrigger_Pyro_Heartfire_Damaged_Healing_Actions)
end)

function AbilityTrigger_Pyro_Heartfire_Damaged_Healing_Actions()    
    local damage = GetEventDamage()
    local dtype = BlzGetEventDamageType()

    if dtype == DAMAGE_TYPE_FIRE then
        BlzSetEventDamage(0.00)
        CauseHealUnscaled(BlzGetEventDamageTarget(), BlzGetEventDamageTarget(), damage)
    end
end