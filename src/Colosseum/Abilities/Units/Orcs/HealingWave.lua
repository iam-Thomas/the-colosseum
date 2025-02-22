AbilityTrigger_Shaman_HealingWave = nil

RegInit(function()
    AbilityTrigger_Shaman_HealingWave = AddAbilityCastTrigger('A043', AbilityTrigger_Shaman_HealingWave_Actions)
end)

function AbilityTrigger_Shaman_HealingWave_Actions()
    local caster = GetSpellAbilityUnit()
    local target = GetSpellTargetUnit()

    local startPoint = GetUnitLoc(caster)

    local targetGroup = CreateGroup()
    GroupAddUnit(targetGroup, target)
    local baseHealing = 1.00

    FireHomingProjectile_PointToUnit(startPoint, target, "Abilities\\Weapons\\WaterElementalMissile\\WaterElementalMissile.mdl", 550.00, 0.32, function()
        RemoveLocation(startPoint)
        local maxLife = GetUnitState(target, UNIT_STATE_MAX_LIFE)
        CauseHealUnscaled(caster, target, maxLife * 0.16 * baseHealing)
        AbilityTrigger_Shaman_HealingWave_Iterate(caster, target, 2, baseHealing * 0.8, targetGroup)
    end)
end

function AbilityTrigger_Shaman_HealingWave_Iterate(caster, currentUnit, n, baseHealing, group)
    if n < 1 then
        return
    end

    local loc = GetUnitLoc(currentUnit)
    -- Add the current unit to a group which should not be selected, so that the wave cannot bounce on the same unit
    local potentialTargets = GetUnitsInRange_FriendlyTargetable(caster, loc, 500.00)
    local target = GetClosestUnitInTableFromPoint_NotInGroup(potentialTargets, loc, group)
    if target == nil then
        return
    end

    GroupAddUnit(group, target)

    FireHomingProjectile_PointToUnit(loc, target, "Abilities\\Weapons\\WaterElementalMissile\\WaterElementalMissile.mdl", 550.00, 0.32, function()
        RemoveLocation(loc)
        local maxLife = GetUnitState(target, UNIT_STATE_MAX_LIFE)
        CauseHealUnscaled(caster, target, maxLife * 0.16 * baseHealing)
        AbilityTrigger_Shaman_HealingWave_Iterate(caster, target, n - 1, baseHealing * 0.8, group)
    end)
end