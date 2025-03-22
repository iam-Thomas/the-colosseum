RegInit(function()
    AddAbilityCastTrigger('A0AH', AbilityTrigger_Sef_EarthPillar)
end)

function AbilityTrigger_Sef_EarthPillar()
    local caster = GetSpellAbilityUnit()
    local targetLoc = GetSpellTargetLoc()

    local damage = 80

    local nAoE = 0
    if IsUnitEmpowered(caster) then
        nAoE = nAoE + 3
    end
    
    AbilityTrigger_Sef_EarthPillar_Start(caster, targetLoc)
    for i = 1, nAoE do
        local loc = PolarProjectionBJ(targetLoc, math.random(140, 500), math.random(0, 360))
        AbilityTrigger_Sef_EarthPillar_Start(caster, loc)
        RemoveLocation(loc)
    end

    RemoveLocation(targetLoc)
end

function AbilityTrigger_Sef_EarthPillar_Start(caster, location)
    local targetLoc = Location(GetLocationX(location), GetLocationY(location))
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