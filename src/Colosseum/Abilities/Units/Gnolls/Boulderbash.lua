AbilityTrigger_Boulderbash = nil

RegInit(function()
    AbilityTrigger_Boulderbash = AddAbilityCastTrigger(BoulderbashSID, AbilityTrigger_Boulderbash_Actions)
end)

function AbilityTrigger_Boulderbash_Actions()
    local caster = GetEventDamageSource()
    local casterPoint = GetUnitLoc(caster)
    local target = BlzGetEventDamageTarget()
    local targetPoint = GetUnitLoc(target)

    Knockback_Angled(target, AngleBetweenPoints(casterPoint, targetPoint), 650, function()
        -- code
    end)

end