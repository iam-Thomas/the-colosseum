function AbilityTrigger_Vagabond_SimulateAttack(caster, target, damage)
    local casterLoc = GetUnitLoc(caster)
    local targetLoc = GetUnitLoc(target)
    FireProjectile_PointToPoint(casterLoc, targetLoc, "Abilities\\Weapons\\MoonPriestessMissile\\MoonPriestessMissile.mdl", 1750, 0.06, function()
        CausePhysicalDamage_Hero(caster, target, damage)
    end, math.pi/2 * 0.08, 0.08)
    RemoveLocation(casterLoc)
    RemoveLocation(targetLoc)
end