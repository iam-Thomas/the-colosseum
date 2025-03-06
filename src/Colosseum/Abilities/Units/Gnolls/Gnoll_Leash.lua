AbilityTrigger_Gnoll_Leash = nil

RegInit(function()
    AbilityTrigger_Gnoll_Leash = AddAbilityCastTrigger(GnollLeashSID, AbilityTrigger_Gnoll_Leash_Actions)
end)

function AbilityTrigger_Gnoll_Leash_Actions()
    local caster = GetSpellAbilityUnit()
    local casterPoint = GetUnitLoc(caster)
    local target = GetSpellTargetUnit()

    FireHomingProjectile_PointToUnit(casterPoint, target, "Abilities\\Spells\\Orc\\Ensnare\\EnsnareMissile.mdl", 700, 0, function()
        local sourcePoint = GetUnitLoc(caster)
        local targetPoint = GetUnitLoc(target)
        local distance = DistanceBetweenPoints(sourcePoint, targetPoint) - 160
        Knockback_Angled(target, AngleBetweenPoints(targetPoint, sourcePoint), distance, nil)
        RemoveLocation(sourcePoint)  
        RemoveLocation(targetPoint)  
    end)

    RemoveLocation(casterPoint)   
end