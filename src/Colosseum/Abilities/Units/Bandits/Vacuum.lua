AbilityTrigger_Bandit_Vacuum = nil

RegInit(function()
    AbilityTrigger_Bandit_Vacuum = AddAbilityCastTrigger('A03Y', AbilityTrigger_Bandit_Vacuum_Actions)
end)

function AbilityTrigger_Bandit_Vacuum_Actions()
    local caster = GetSpellAbilityUnit()
    local targetLoc = GetSpellTargetLoc()

    local effect = CreateEffectAtPoint(targetLoc, "Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl", 3.0)

    BlzSetSpecialEffectScale(effect, 1.5)
    BlzSetSpecialEffectAlpha(effect, 100)

    local ticks = 0
    local timer = CreateTimer()
    TimerStart(timer, 0.03, true, function()
        if ticks >= 50 then
            DestroyTimer(timer)
            RemoveLocation(targetLoc)
            return
        end
        ticks = ticks + 1

        local units = GetUnitsInRange_EnemyGroundTargetable(caster, targetLoc, 315)
        for i = 1, #units do
            local unit = units[i]
            local unitLoc = GetUnitLoc(unit)
            local angle = AngleBetweenPoints(unitLoc, targetLoc)
            
            local newLoc = PolarProjectionBJ(unitLoc, 140 * 0.03, angle)
            SetUnitX(unit, GetLocationX(newLoc))
            SetUnitY(unit, GetLocationY(newLoc))

            RemoveLocation(unitLoc)
            RemoveLocation(newLoc)
        end
    end)
end