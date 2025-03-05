AbilityTrigger_Gnoll_Leash = nil

RegInit(function()
    AbilityTrigger_Gnoll_Leash = AddAbilityCastTrigger(GnollLeashSID, AbilityTrigger_Gnoll_Leash_Actions)
end)

function AbilityTrigger_Gnoll_Leash_Actions()
    local caster = GetEventDamageSource()
    local casterPoint = GetUnitLoc(caster)
    local target = BlzGetEventDamageTarget()
    local targetPoint = GetUnitLoc(target)

    local distance = DistanceBetweenPoints(targetPoint, casterPoint) / 2

    Knockback_Angled(target, AngleBetweenPoints(targetPoint, casterPoint), distance, function()
        -- code
    end)

end