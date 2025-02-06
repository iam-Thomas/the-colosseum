AbilityTrigger_Grunt_CullTheWeak_Damaging = nil

RegInit(function()
    AbilityTrigger_Grunt_CullTheWeak_Damaging = AddDamagingEventTrigger_CasterHasAbility(FourCC('A061'), AbilityTrigger_Grunt_CullTheWeak_Damaging_Actions)
end)

function AbilityTrigger_Grunt_CullTheWeak_Damaging_Actions()
    local isAttack = BlzGetEventIsAttack()
    if not isAttack then
        return
    end

    local target = BlzGetEventDamageTarget()
    local damage = GetEventDamage()

    if IsUnitVulnerable(target) then
        BlzSetEventDamage(damage * 1.75)
    end
end