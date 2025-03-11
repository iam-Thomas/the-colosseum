RegInit(function()
    AddAbilityCastTrigger('A0AH', AbilityTrigger_Sef_EarthPillar)
end)

function AbilityTrigger_Sef_EarthPillar()
    local caster = GetSpellAbilityUnit()
    local targetLoc = GetSpellTargetLoc()

    local damage = 80

    
    DangerAreaAt(targetLoc, 2.0, 180)

    DelayedCallback(2.0, function()
        local unit = CreateUnitAtLoc(GetOwningPlayer(caster), FourCC('n017'), targetLoc, 0)
        local moveLoc = GetUnitValidLoc(targetLoc)
        SetUnitX(unit, GetLocationX(moveLoc))
        SetUnitY(unit, GetLocationY(moveLoc))
        local unitLoc = GetUnitLoc(unit)

        local targets = GetUnitsInRange_EnemyTargetable(caster, unitLoc, 180)
        for i = 1, #targets do
            local target = targets[i]
            local targetUnitLoc = GetUnitLoc(target)
            local kbAngle = AngleBetweenPoints(unitLoc, targetUnitLoc)
            CauseMagicDamage(caster, target, damage)
            CauseStun3s(caster, target)
            Knockback_Angled(target, kbAngle, 100, nil)
        end
        
        local effect = AddSpecialEffectLoc("abilities\\weapons\\catapult\\catapultmissile.mdl", targetLoc)
        BlzSetSpecialEffectScale(effect, 2.0)
        DestroyEffect(effect)
        RemoveLocation(targetLoc)
        RemoveLocation(unitLoc)
        RemoveLocation(moveLoc)
    end)
end