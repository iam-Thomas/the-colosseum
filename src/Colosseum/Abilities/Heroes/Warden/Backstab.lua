RegInit(function()
    local trigger = AddDamagingEventTrigger_CasterHasAbility(FourCC('A01D'), AbilityTrigger_Warden_Backstab)
end)

function AbilityTrigger_Warden_Backstab()
    if not Event_IsHitEffect() then
        return
    end

    local caster = GetEventDamageSource()
    local target = BlzGetEventDamageTarget()
    local casterLoc = GetUnitLoc(caster)
    local targetLoc = GetUnitLoc(target)
    local targetFacingAngle = GetUnitFacing(target)

    local angleToCaster = AngleBetweenPoints(targetLoc, casterLoc)
    local angleDifference = angleToCaster - targetFacingAngle
    angleDifference = ModuloReal((angleDifference + 180.00), 360.00) - 180.00
    if math.abs(angleDifference) <= 90 then
        return
    end

    BlzSetEventDamage(GetEventDamage() * 1.3)
    CreateEffectOnUnit("chest", target, "Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl", 2.00)
end