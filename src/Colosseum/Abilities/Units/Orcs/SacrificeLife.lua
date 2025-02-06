AbilityTrigger_OrcWarlock_SacrificeLife = nil

RegInit(function()
    AbilityTrigger_OrcWarlock_SacrificeLife = AddAbilityCastTrigger('A06O', AbilityTrigger_OrcWarlock_SacrificeLife_Actions)
end)

function AbilityTrigger_OrcWarlock_SacrificeLife_Actions()
    local caster = GetSpellAbilityUnit()
    local casterLoc = GetUnitLoc(caster)

    --Abilities\Weapons\NecromancerMissile\NecromancerMissile.mdl

    local units = GetUnitsInRange_FriendlyTargetable(caster, casterLoc, 800)
    for i = 1, #units do
        local srcUnit = units[i]
        local startPoint = GetUnitLoc(units[i])

        local maxLife = GetUnitState(srcUnit, UNIT_STATE_MAX_LIFE)
        local life = GetUnitState(srcUnit, UNIT_STATE_LIFE)
        local drained = maxLife * 0.10
        SetUnitState(srcUnit, UNIT_STATE_LIFE, life - drained)

        FireHomingProjectile_PointToUnit(startPoint, caster, "Abilities\\Weapons\\NecromancerMissile\\NecromancerMissile.mdl", 550, 0.08, function()
            CauseHealUnscaled(caster, caster, drained)
        end)
    end    
end