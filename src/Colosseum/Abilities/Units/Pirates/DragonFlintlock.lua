AbilityTrigger_Dragon_Flintlock = nil

RegInit(function()
    AbilityTrigger_Dragon_Flintlock = AddAbilityCastTrigger('A08N', AbilityTrigger_Dragon_Flintlock_Actions)
end)

function AbilityTrigger_Dragon_Flintlock_Actions()
    local caster = GetSpellAbilityUnit()
    local castPoint = GetUnitLoc(caster)
    local target = GetSpellTargetUnit()
    
    FireHomingProjectile_PointToUnit(castPoint, target, "Abilities\\Weapons\\BoatMissile\\BoatMissile.mdl", 2000, 0, function()
        if FourCC('o00H') == GetUnitTypeId(target) then
            KillUnit(target)
            return
        end

        CauseNormalDamage(caster, target, 150)
        CauseStun3s(caster, target)
    end)

    RemoveLocation(castPoint)
    
end
